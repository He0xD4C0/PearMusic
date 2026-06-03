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
/// Responsibilities:
/// - Playback control (play, pause, skip, seek)
/// - Queue management (view, reorder, insert, remove)
/// - Shuffle and repeat modes
/// - Continuous progress tracking via Timer
/// - System integration: MPNowPlayingInfoCenter, MPRemoteCommandCenter
///
/// All public methods are `@MainActor` because `ApplicationMusicPlayer`
/// is MainActor-isolated.
@MainActor
@Observable
public final class PlaybackEngine {

    public static let shared = PlaybackEngine()

    // MARK: - Internal Player

    private let player = ApplicationMusicPlayer.shared

    // MARK: - Shadow Queue

    /// Our managed queue — the source of truth for queue display.
    /// Mirrors what we've sent to `ApplicationMusicPlayer`.
    private var shadowQueue: [QueueEntry] = []

    /// Index into `shadowQueue` of the currently playing song.
    private var currentIndex: Int = -1

    // MARK: - Playback State

    public private(set) var isPlaying: Bool = false
    public private(set) var currentTime: TimeInterval = 0
    public private(set) var duration: TimeInterval = 0
    public private(set) var nowPlaying: Song?
    public private(set) var repeatMode: RepeatMode = .none
    public private(set) var shuffleMode: ShuffleMode = .off

    /// Error surfaced to the UI.
    public var errorMessage: String?

    // MARK: - Queue Access

    /// The full queue, with the current song at index 0 (if playing).
    public var queue: [QueueEntry] { shadowQueue }

    /// Upcoming songs (after the current track).
    public var upcomingQueue: [QueueEntry] {
        guard currentIndex >= 0, currentIndex < shadowQueue.count else { return [] }
        return Array(shadowQueue[(currentIndex + 1)...])
    }

    /// History (songs before the current track).
    public var history: [QueueEntry] {
        guard currentIndex > 0 else { return [] }
        return Array(shadowQueue[0..<currentIndex])
    }

    /// Total count of items in the queue.
    public var queueCount: Int { shadowQueue.count }

    // MARK: - Progress Timer

    nonisolated private var progressTimer: Timer?

    // MARK: - Initialization

    private init() {
        setupRemoteCommands()
    }

    deinit {
        progressTimer?.invalidate()
    }

    // MARK: - Playback Controls

    /// Plays a single song, replacing the queue.
    public func play(song: Song) async throws {
        shadowQueue = [QueueEntry(song: song)]
        currentIndex = 0
        player.queue = [song]
        try await player.play()
        refreshNowPlaying()
        startProgressTimer()
    }

    /// Plays an array of songs starting from a specific index.
    public func play(songs: [Song], startIndex: Int = 0) async throws {
        guard !songs.isEmpty else {
            throw PearMusicError.queueEmpty
        }
        let clampedIndex = min(max(startIndex, 0), songs.count - 1)
        shadowQueue = songs.map { QueueEntry(song: $0) }
        currentIndex = clampedIndex
        player.queue = ApplicationMusicPlayer.Queue(for: songs, startingAt: songs[clampedIndex])
        try await player.play()
        refreshNowPlaying()
        startProgressTimer()
    }

    /// Resumes playback of the current queue.
    public func play() async throws {
        guard !shadowQueue.isEmpty else {
            throw PearMusicError.noActiveQueue
        }
        try await player.play()
        refreshNowPlaying()
        startProgressTimer()
    }

    /// Pauses playback.
    public func pause() {
        player.pause()
        refreshNowPlaying()
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
            // End of queue, no repeat
            stop()
            return
        }

        if nextIndex == currentIndex {
            // Repeat One — seek to beginning
            player.playbackTime = 0
            refreshNowPlaying()
            return
        }

        // Play next song
        if nextIndex < shadowQueue.count {
            let nextSong = shadowQueue[nextIndex].song
            currentIndex = nextIndex
            player.queue = [nextSong]
            try await player.play()
            // Rebuild remaining queue for upcoming tracks
            rebuildUpcomingQueue(from: nextIndex)
        }
        refreshNowPlaying()
    }

    /// Skips to the previous track.
    /// If >3 seconds into the song, restarts the current song.
    public func skipToPrevious() async throws {
        if currentTime > 3.0 {
            // Restart current song
            player.playbackTime = 0
            refreshNowPlaying()
            return
        }

        // Go to previous song
        let prevIndex = currentIndex - 1
        guard prevIndex >= 0 else {
            // Already at first song — restart it
            player.playbackTime = 0
            refreshNowPlaying()
            return
        }

        let prevSong = shadowQueue[prevIndex].song
        currentIndex = prevIndex
        player.queue = [prevSong]
        try await player.play()
        rebuildUpcomingQueue(from: prevIndex)
        refreshNowPlaying()
    }

    /// Seeks to a specific time in the current song.
    public func seek(to time: TimeInterval) async {
        player.playbackTime = time
        refreshNowPlaying()
    }

    // MARK: - Queue Management

    /// Adds a song to the end of the queue.
    public func addToQueue(_ song: Song) {
        let entry = QueueEntry(song: song)
        shadowQueue.append(entry)
        Task { @MainActor in
            try? await player.queue.insert(song, position: .tail)
        }
    }

    /// Inserts a song to play immediately after the current track.
    public func playNext(_ song: Song) {
        let entry = QueueEntry(song: song)
        let insertIndex = currentIndex + 1
        shadowQueue.insert(entry, at: insertIndex)
        if insertIndex <= currentIndex {
            currentIndex += 1
        }
        Task { @MainActor in
            try? await player.queue.insert(song, position: .afterCurrentEntry)
        }
    }

    /// Removes a song from the shadow queue by ID.
    public func removeFromQueue(id: String) {
        guard let removeIndex = shadowQueue.firstIndex(where: { $0.id == id }) else { return }
        if removeIndex < currentIndex {
            currentIndex -= 1
        } else if removeIndex == currentIndex {
            // Removing the current song — skip to next
            shadowQueue.remove(at: removeIndex)
            Task {
                try? await skipToNext()
            }
            return
        }
        shadowQueue.remove(at: removeIndex)
    }

    /// Moves a song within the shadow queue (drag reorder).
    public func moveInQueue(from source: IndexSet, to destination: Int) {
        var mutable = shadowQueue
        mutable.move(fromOffsets: source, toOffset: destination)

        // Adjust currentIndex
        let oldIndex = currentIndex
        shadowQueue = mutable

        // Find where the current song moved
        if let newCurrentIdx = shadowQueue.firstIndex(where: { $0.id == shadowQueue[oldIndex].id }) {
            currentIndex = newCurrentIdx
        }

        // Rebuild upcoming portion of the player queue
        rebuildUpcomingQueue(from: currentIndex)
    }

    /// Clears all upcoming songs (keeps current).
    public func clearUpcoming() {
        guard currentIndex >= 0 else { return }
        shadowQueue = Array(shadowQueue[0...currentIndex])
    }

    // MARK: - Repeat & Shuffle

    /// Cycles to the next repeat mode.
    public func cycleRepeatMode() {
        switch repeatMode {
        case .none: repeatMode = .all
        case .all:  repeatMode = .one
        case .one:  repeatMode = .none
        }
    }

    /// Toggles shuffle mode.
    public func toggleShuffle() {
        shuffleMode = (shuffleMode == .off) ? .on : .off

        if shuffleMode == .on, currentIndex >= 0 {
            // Keep current song, shuffle the remaining
            _ = shadowQueue[currentIndex]
            var upcoming = Array(shadowQueue[(currentIndex + 1)...])
            upcoming.shuffle()
            shadowQueue = Array(shadowQueue[0...currentIndex]) + upcoming
            rebuildUpcomingQueue(from: currentIndex)
        } else if shuffleMode == .off {
            // Can't un-shuffle — original order is lost.
            // In a production app we'd store the original order.
        }
    }

    // MARK: - Search

    /// Searches the Apple Music catalog.
    public func search(query: String, limit: Int = 25) async throws -> [Song] {
        var request = MusicCatalogSearchRequest(
            term: query,
            types: [Song.self]
        )
        request.limit = limit

        let response = try await request.response()
        return Array(response.songs)
    }

    /// Searches by artist and title.
    public func search(title: String, artist: String, limit: Int = 10) async throws -> [Song] {
        var request = MusicCatalogSearchRequest(
            term: "\(title) \(artist)",
            types: [Song.self]
        )
        request.limit = limit

        let response = try await request.response()
        return Array(response.songs)
    }

    // MARK: - State Refresh

    /// Updates all @Observable properties from the live player.
    private func refreshNowPlaying() {
        let song = player.queue.currentEntry?.item as? Song
        if song?.id != nowPlaying?.id {
            nowPlaying = song
            updateNowPlayingInfo()
        }
        isPlaying = player.state.playbackStatus == .playing
        currentTime = player.playbackTime
        if let dur = song?.duration {
            duration = dur
        }
        errorMessage = nil
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

        // Detect song end and auto-advance
        if duration > 0, currentTime >= duration - 0.5 {
            Task { @MainActor [weak self] in
                try? await self?.skipToNext()
            }
        }
    }

    // MARK: - Upcoming Queue Rebuild

    /// Rebuilds the player's upcoming queue from `fromIndex + 1` onward.
    private func rebuildUpcomingQueue(from index: Int) {
        let upcoming = shadowQueue[(index + 1)...]
        for entry in upcoming {
            Task { @MainActor in
                try? await player.queue.insert(entry.song, position: .tail)
            }
        }
    }

    // MARK: - Index Resolution

    /// Determines the next index based on repeat mode, shuffle, and bounds.
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

    /// Configures MPNowPlayingInfoCenter and MPRemoteCommandCenter.
    private func setupRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        // Play
        center.playCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.play()
            }
            return .success
        }

        // Pause
        center.pauseCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.pause()
            }
            return .success
        }

        // Toggle play/pause
        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.togglePlayPause()
            }
            return .success
        }

        // Next
        center.nextTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.skipToNext()
            }
            return .success
        }

        // Previous
        center.previousTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                try? await self?.skipToPrevious()
            }
            return .success
        }

        // Seek
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

    /// Publishes the current track to MPNowPlayingInfoCenter.
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

        // Artwork is loaded asynchronously to avoid blocking
        if let artwork = song.artwork {
            info[MPMediaItemPropertyArtwork] = placeholderArtwork()
            Task {
                if let loadedArtwork = await loadArtworkMP(artwork) {
                    var updated = center.nowPlayingInfo ?? [:]
                    updated[MPMediaItemPropertyArtwork] = loadedArtwork
                    center.nowPlayingInfo = updated
                }
            }
        }

        center.nowPlayingInfo = info
        center.playbackState = isPlaying ? .playing : .paused
    }

    /// Clears the NowPlaying info center.
    private func clearNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    /// Generates a small placeholder artwork to avoid NowPlaying widget flicker.
    private func placeholderArtwork() -> MPMediaItemArtwork {
        MPMediaItemArtwork(boundsSize: CGSize(width: 1, height: 1)) { _ in
            #if os(macOS)
            return NSImage()
            #else
            return UIImage()
            #endif
        }
    }

    /// Loads MusicKit artwork into an MPMediaItemArtwork.
    private func loadArtworkMP(_ artwork: Artwork) async -> MPMediaItemArtwork? {
        let size = CGSize(width: 600, height: 600)
        let url = artwork.url(width: Int(size.width), height: Int(size.height))

        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
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
