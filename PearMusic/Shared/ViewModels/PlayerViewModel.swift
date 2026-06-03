import Foundation
import MusicKit
import Observation

// MARK: - Player View Model

/// Primary player state bridge between `PlaybackEngine` / `MusicAuthManager`
/// and SwiftUI views.
///
/// Uses **stored properties** refreshed by a 4 Hz timer because `@Observable`
/// only tracks stored property mutations — computed properties that delegate
/// across object boundaries do not trigger SwiftUI re-renders.
///
/// Basic transport controls (play, pause, skip) catch errors internally and
/// set `errorMessage` for the UI — callers don't need `try`. Throwing variants
/// are available for programmatic use.
@MainActor
@Observable
public final class PlayerViewModel {

    public static let shared = PlayerViewModel()

    // MARK: - Dependencies

    private let auth = MusicAuthManager.shared
    private let engine = PlaybackEngine.shared

    // MARK: - Auth State (stored + refreshed)

    public private(set) var authorizationStatus: MusicAuthorization.Status = .notDetermined
    public var isAuthorized: Bool { authorizationStatus == .authorized }

    // MARK: - Playback State (stored + refreshed by timer)

    public private(set) var isPlaying: Bool = false
    public private(set) var currentTime: TimeInterval = 0
    public private(set) var duration: TimeInterval = 0
    public private(set) var nowPlayingTitle: String?
    public private(set) var nowPlayingArtist: String?
    public private(set) var nowPlayingAlbum: String?
    public private(set) var nowPlayingArtworkURL: URL?
    public private(set) var errorMessage: String?

    // MARK: - Modes (stored + refreshed)

    public private(set) var repeatMode: RepeatMode = .none
    public private(set) var shuffleMode: ShuffleMode = .off

    // MARK: - Queue (computed — rarely changes, updated on actions)

    public var queue: [QueueEntry] { engine.queue }
    public var queueCount: Int { engine.queueCount }
    public var upcomingQueue: [QueueEntry] { engine.upcomingQueue }
    public var history: [QueueEntry] { engine.history }

    // MARK: - Auth Status Messages

    public var authStatusMessage: String {
        switch authorizationStatus {
        case .notDetermined:
            return "Apple Music access is required to play songs and display synced lyrics."
        case .authorized:
            return "Apple Music authorized."
        case .denied:
            return "Apple Music access was denied. Enable it in System Settings → Privacy → Media & Apple Music."
        case .restricted:
            return "Apple Music access is restricted on this device. Check Screen Time or device management settings."
        @unknown default:
            return "Unknown authorization state."
        }
    }

    public var authStatusSymbol: String {
        switch authorizationStatus {
        case .notDetermined: return "music.note"
        case .authorized:    return "music.note.house.fill"
        case .denied:        return "music.note.slash"
        case .restricted:    return "lock.shield"
        @unknown default:    return "questionmark"
        }
    }

    // MARK: - Timer

    private var uiTimer: Timer?

    // MARK: - Init

    private init() {
        refreshAuthState()
        refreshPlaybackState()
        startUITimer()
    }

    deinit {
        uiTimer?.invalidate()
    }

    // MARK: - Authorization

    public func authorize() async {
        _ = await auth.requestAuthorization()
        refreshAuthState()
    }

    public func checkAuthorization() {
        refreshAuthState()
    }

    public func openSystemSettings() {
        auth.openSystemSettings()
    }

    // MARK: - Playback Controls (error-catching for UI)

    public func play() async {
        do {
            try await engine.play()
        } catch {
            errorMessage = error.localizedDescription
        }
        refreshPlaybackState()
    }

    public func pause() {
        engine.pause()
        refreshPlaybackState()
    }

    public func togglePlayPause() async {
        do {
            try await engine.togglePlayPause()
        } catch {
            errorMessage = error.localizedDescription
        }
        refreshPlaybackState()
    }

    public func skipToNext() async {
        do {
            try await engine.skipToNext()
        } catch {
            errorMessage = error.localizedDescription
        }
        refreshPlaybackState()
    }

    public func skipToPrevious() async {
        do {
            try await engine.skipToPrevious()
        } catch {
            errorMessage = error.localizedDescription
        }
        refreshPlaybackState()
    }

    public func seek(to time: TimeInterval) async {
        await engine.seek(to: time)
        refreshPlaybackState()
    }

    // MARK: - Play Song (error-catching for UI)

    public func play(song: Song) async {
        do {
            try await engine.play(song: song)
        } catch {
            errorMessage = error.localizedDescription
        }
        refreshPlaybackState()
    }

    public func play(songs: [Song], startIndex: Int = 0) async {
        do {
            try await engine.play(songs: songs, startIndex: startIndex)
        } catch {
            errorMessage = error.localizedDescription
        }
        refreshPlaybackState()
    }

    public func searchAndPlay(title: String, artist: String) async {
        do {
            let songs = try await engine.search(title: title, artist: artist)
            guard let firstSong = songs.first else {
                errorMessage = "No results found for \"\(title)\""
                return
            }
            try await engine.play(song: firstSong)
        } catch {
            errorMessage = error.localizedDescription
        }
        refreshPlaybackState()
    }

    // MARK: - Search

    public func search(query: String, limit: Int = 25) async throws -> [Song] {
        try await engine.search(query: query, limit: limit)
    }

    // MARK: - Queue Management

    public func addToQueue(_ song: Song) { engine.addToQueue(song) }
    public func playNext(_ song: Song) { engine.playNext(song) }
    public func removeFromQueue(id: String) { engine.removeFromQueue(id: id) }
    public func moveInQueue(from source: IndexSet, to destination: Int) { engine.moveInQueue(from: source, to: destination) }
    public func clearUpcomingQueue() { engine.clearUpcoming() }

    // MARK: - Repeat / Shuffle

    public func cycleRepeatMode() {
        engine.cycleRepeatMode()
        refreshModesState()
    }

    public func toggleShuffle() {
        engine.toggleShuffle()
        refreshModesState()
    }

    // MARK: - State Refresh

    private func refreshAuthState() {
        authorizationStatus = auth.status
    }

    private func refreshPlaybackState() {
        isPlaying = engine.isPlaying
        currentTime = engine.currentTime
        duration = engine.duration
        nowPlayingTitle = engine.nowPlaying?.title
        nowPlayingArtist = engine.nowPlaying?.artistName
        nowPlayingAlbum = engine.nowPlaying?.albumTitle
        nowPlayingArtworkURL = engine.nowPlaying?.artwork?.url(width: 300, height: 300)
        errorMessage = engine.errorMessage
        refreshModesState()
    }

    private func refreshModesState() {
        repeatMode = engine.repeatMode
        shuffleMode = engine.shuffleMode
    }

    // MARK: - Timer

    /// 4 Hz timer refreshes stored properties so SwiftUI sees changes.
    private func startUITimer() {
        uiTimer?.invalidate()
        uiTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.refreshPlaybackState()
            }
        }
    }
}
