import Foundation
import MusicKit
import MediaPlayer
import SwiftUI
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

// MARK: - Playback Modes

public enum RepeatMode: String, Sendable, CaseIterable {
    case none = "None"
    case one = "One"
    case all = "All"
}

public enum ShuffleMode: String, Sendable, CaseIterable {
    case off = "Off"
    case on = "On"
}

// MARK: - Queue Entry

/// Shadow queue entry — mirrors a MusicKit song in our managed queue.
public struct QueueEntry: Identifiable, Equatable, Sendable {
    public let id: String
    public let song: Song

    public init(song: Song) {
        self.id = song.id.rawValue
        self.song = song
    }

    public static func == (lhs: QueueEntry, rhs: QueueEntry) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Playback Engine

/// Core playback engine wrapping `ApplicationMusicPlayer.shared`.
///
/// **Key design decision**: The shadow queue is the sole source of truth for
/// track identity. The system player only ever receives single-song queues
/// to avoid the "Queue was interrupted by another queue" error. No inserts
/// or rebuilds are performed on the system player queue.
@MainActor
@Observable
public final class PlaybackEngine {

    public static let shared = PlaybackEngine()

    // MARK: - Internal Player

    private let player = ApplicationMusicPlayer.shared

    // MARK: - Shadow Queue

    /// Our managed queue — the source of truth.
    private var shadowQueue: [QueueEntry] = []

    /// Index into `shadowQueue` of the currently playing song.
    private var currentIndex: Int = -1

    // MARK: - Playback State

    public private(set) var isPlaying: Bool = false
    public private(set) var currentTime: TimeInterval = 0
    public private(set) var duration: TimeInterval = 0
    /// The currently playing song — derived from shadow queue, NOT from
    /// player.queue.currentEntry (which may be nil after queue conflicts).
    public private(set) var nowPlaying: Song?
    public private(set) var repeatMode: RepeatMode = .none
    public private(set) var shuffleMode: ShuffleMode = .off

    /// Error surfaced to the UI.
    public var errorMessage: String?

    // MARK: - Queue Access

    public var queue: [QueueEntry] { shadowQueue }

    public var upcomingQueue: [QueueEntry] {
        guard currentIndex >= 0, currentIndex < shadowQueue.count else { return [] }
        return Array(shadowQueue[(currentIndex + 1)...])
    }

    public var history: [QueueEntry] {
        guard currentIndex > 0 else { return [] }
        return Array(shadowQueue[0..<currentIndex])
    }

    public var queueCount: Int { shadowQueue.count }

    // MARK: - Progress Timer

    private var progressTimer: Timer?

    // MARK: - Initialization

    private init() {
        setupRemoteCommands()
    }

    deinit {
        MainActor.assumeIsolated {
            progressTimer?.invalidate()
        }
    }

    // MARK: - Playback Controls

    /// Plays a single song, replacing the queue.
    public func play(song: Song) async throws {
        player.stop()
        shadowQueue = [QueueEntry(song: song)]
        currentIndex = 0
        setNowPlaying(at: 0)
        player.queue = [song]
        try await player.play()
        refreshPlaybackState()
        startProgressTimer()
    }

    /// Plays an array of songs starting from a specific index.
    /// Only the starting song is sent to the system player — the rest
    /// lives in the shadow queue and is played via `skipToNext()`.
    public func play(songs: [Song], startIndex: Int = 0) async throws {
        guard !songs.isEmpty else { return }
        let clampedIndex = min(max(startIndex, 0), songs.count - 1)
        player.stop()
        shadowQueue = songs.map { QueueEntry(song: $0) }
        currentIndex = clampedIndex
        setNowPlaying(at: clampedIndex)
        player.queue = [songs[clampedIndex]]
        try await player.play()
        refreshPlaybackState()
        startProgressTimer()
    }

    /// Resumes playback of the current queue.
    public func play() async throws {
        guard currentIndex >= 0, currentIndex < shadowQueue.count else { return }
        try await player.play()
        refreshPlaybackState()
        startProgressTimer()
    }

    /// Pauses playback.
    public func pause() {
        player.pause()
        refreshPlaybackState()
        stopProgressTimer()
    }

    /// Toggles play/pause.
    public func togglePlayPause() async throws {
        if isPlaying {
            pause()
        } else {
            try await play()
        }
    }

    /// Stops playback and clears the queue.
    public func stop() {
        player.stop()
        shadowQueue = []
        currentIndex = -1
        nowPlaying = nil
        stopProgressTimer()
        clearNowPlaying()
    }

    // MARK: - Skip

    /// Skips to the next track in the queue.
    public func skipToNext() async throws {
        let nextIndex = resolveNextIndex()

        if nextIndex == -1 {
            stop()
            return
        }

        if nextIndex == currentIndex {
            // Repeat One — seek to beginning
            player.playbackTime = 0
            refreshPlaybackState()
            return
        }

        // Play next song from shadow queue
        if nextIndex < shadowQueue.count {
            currentIndex = nextIndex
            setNowPlaying(at: nextIndex)
            player.queue = [shadowQueue[nextIndex].song]
            try await player.play()
        }
        refreshPlaybackState()
    }

    /// Skips to the previous track. Restarts current if >3s in.
    public func skipToPrevious() async throws {
        if currentTime > 3.0 {
            player.playbackTime = 0
            refreshPlaybackState()
            return
        }

        let prevIndex = currentIndex - 1
        guard prevIndex >= 0 else {
            player.playbackTime = 0
            refreshPlaybackState()
            return
        }

        currentIndex = prevIndex
        setNowPlaying(at: prevIndex)
        player.queue = [shadowQueue[prevIndex].song]
        try await player.play()
        refreshPlaybackState()
    }

    /// Seeks to a position in the current song.
    public func seek(to time: TimeInterval) async {
        player.playbackTime = time
        currentTime = time
    }

    // MARK: - Queue Management (shadow only — no system player inserts)

    /// Adds a song to the end of the shadow queue.
    public func addToQueue(_ song: Song) {
        shadowQueue.append(QueueEntry(song: song))
    }

    /// Inserts a song to play immediately after the current track.
    public func playNext(_ song: Song) {
        let entry = QueueEntry(song: song)
        let insertIndex = currentIndex + 1
        shadowQueue.insert(entry, at: insertIndex)
    }

    /// Removes a song from the shadow queue by ID.
    public func removeFromQueue(id: String) {
        guard let removeIndex = shadowQueue.firstIndex(where: { $0.id == id }) else { return }
        if removeIndex < currentIndex {
            currentIndex -= 1
        } else if removeIndex == currentIndex {
            shadowQueue.remove(at: removeIndex)
            Task { try? await skipToNext() }
            return
        }
        shadowQueue.remove(at: removeIndex)
    }

    /// Moves a song within the shadow queue (drag reorder).
    public func moveInQueue(from source: IndexSet, to destination: Int) {
        var mutable = shadowQueue
        mutable.move(fromOffsets: source, toOffset: destination)
        let oldIndex = currentIndex
        shadowQueue = mutable
        if oldIndex >= 0, oldIndex < shadowQueue.count {
            // Find where the current song moved
            if let newIdx = shadowQueue.firstIndex(where: { $0.id == shadowQueue[min(oldIndex, shadowQueue.count - 1)].id }) {
                currentIndex = newIdx
            }
        }
    }

    /// Clears all upcoming songs (keeps current).
    public func clearUpcoming() {
        guard currentIndex >= 0 else { return }
        shadowQueue = Array(shadowQueue[0...currentIndex])
    }

    // MARK: - Repeat & Shuffle

    public func cycleRepeatMode() {
        switch repeatMode {
        case .none: repeatMode = .all
        case .all:  repeatMode = .one
        case .one:  repeatMode = .none
        }
    }

    public func toggleShuffle() {
        shuffleMode = (shuffleMode == .off) ? .on : .off
        if shuffleMode == .on, currentIndex >= 0 {
            var upcoming = Array(shadowQueue[(currentIndex + 1)...])
            upcoming.shuffle()
            shadowQueue = Array(shadowQueue[0...currentIndex]) + upcoming
        }
    }

    // MARK: - Search

    public func search(query: String, limit: Int = 25) async throws -> [Song] {
        var request = MusicCatalogSearchRequest(term: query, types: [Song.self])
        request.limit = limit
        let response = try await request.response()
        return Array(response.songs)
    }

    public func search(title: String, artist: String, limit: Int = 10) async throws -> [Song] {
        var request = MusicCatalogSearchRequest(
            term: "\(title) \(artist)",
            types: [Song.self]
        )
        request.limit = limit
        let response = try await request.response()
        return Array(response.songs)
    }

    // MARK: - State Management

    /// Sets `nowPlaying` from the shadow queue (NOT from the system player).
    private func setNowPlaying(at index: Int) {
        guard index >= 0, index < shadowQueue.count else { return }
        let song = shadowQueue[index].song
        if song.id != nowPlaying?.id {
            nowPlaying = song
            duration = song.duration ?? 0
            updateNowPlayingInfo()
        }
    }

    /// Refreshes playback state from the system player.
    private func refreshPlaybackState() {
        isPlaying = player.state.playbackStatus == .playing
        currentTime = player.playbackTime
        errorMessage = nil

        // Sync nowPlaying from shadow queue if it's nil but we have songs
        if nowPlaying == nil, currentIndex >= 0, currentIndex < shadowQueue.count {
            setNowPlaying(at: currentIndex)
        }
    }

    // MARK: - Progress Timer

    private func startProgressTimer() {
        stopProgressTimer()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.tick()
            }
        }
    }

    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    private func tick() {
        guard player.state.playbackStatus == .playing else { return }
        currentTime = player.playbackTime
        isPlaying = true

        // Auto-advance when the song ends
        if duration > 0, currentTime >= duration - 0.5 {
            Task { @MainActor [weak self] in
                try? await self?.skipToNext()
            }
        }
    }

    // MARK: - Index Resolution

    private func resolveNextIndex() -> Int {
        switch repeatMode {
        case .none:
            let next = currentIndex + 1
            return next < shadowQueue.count ? next : -1
        case .one:
            return currentIndex
        case .all:
            let next = currentIndex + 1
            return next < shadowQueue.count ? next : 0
        }
    }

    // MARK: - System Integration

    private func setupRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.play()
            }
            return .success
        }

        center.pauseCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.pause()
            }
            return .success
        }

        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.togglePlayPause()
            }
            return .success
        }

        center.nextTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.skipToNext()
            }
            return .success
        }

        center.previousTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.skipToPrevious()
            }
            return .success
        }

        center.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self,
                  let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            Task { @MainActor in
                await self.seek(to: event.positionTime)
            }
            return .success
        }
    }

    private func updateNowPlayingInfo() {
        let center = MPNowPlayingInfoCenter.default()

        guard let song = nowPlaying else {
            center.nowPlayingInfo = nil
            return
        }

        var info: [String: Any] = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artistName,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0,
            MPNowPlayingInfoPropertyPlaybackQueueCount: shadowQueue.count,
            MPNowPlayingInfoPropertyPlaybackQueueIndex: currentIndex,
        ]

        if let albumTitle = song.albumTitle {
            info[MPMediaItemPropertyAlbumTitle] = albumTitle
        }

        // Placeholder artwork while we load the real one
        if song.artwork != nil {
            info[MPMediaItemPropertyArtwork] = placeholderArtwork()
            Task {
                if let artwork = song.artwork,
                   let loadedArtwork = await loadArtworkMP(artwork) {
                    var updated = center.nowPlayingInfo ?? [:]
                    updated[MPMediaItemPropertyArtwork] = loadedArtwork
                    center.nowPlayingInfo = updated
                }
            }
        }

        center.nowPlayingInfo = info
        center.playbackState = isPlaying ? .playing : .paused
    }

    private func clearNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    private func placeholderArtwork() -> MPMediaItemArtwork {
        MPMediaItemArtwork(boundsSize: CGSize(width: 1, height: 1)) { _ in
            #if os(macOS)
            return NSImage()
            #else
            return UIImage()
            #endif
        }
    }

    private func loadArtworkMP(_ artwork: Artwork) async -> MPMediaItemArtwork? {
        let size = CGSize(width: 600, height: 600)
        guard let url = artwork.url(width: Int(size.width), height: Int(size.height)),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            return nil
        }
        #if os(macOS)
        guard let nsImage = NSImage(data: data) else { return nil }
        return MPMediaItemArtwork(boundsSize: size) { _ in nsImage }
        #else
        guard let uiImage = UIImage(data: data) else { return nil }
        return MPMediaItemArtwork(boundsSize: size) { _ in uiImage }
        #endif
    }
}
