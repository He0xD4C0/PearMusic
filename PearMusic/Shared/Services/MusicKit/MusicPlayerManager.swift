import Foundation
@preconcurrency import MusicKit
import Combine

// MARK: - Music Player Manager

/// Wraps the system ApplicationMusicPlayer for PearMusic.
///
/// Key advantages over MusicKit JS:
/// - No manual JWT: MusicKit derives the developer token from code signing
/// - System integration: NowPlaying center, media keys, AirPlay
/// - Native audio engine
@Observable
public final class MusicPlayerManager {

    public static let shared = MusicPlayerManager()

    private let player = ApplicationMusicPlayer.shared
    private var isInitialized = false

    /// Current authorization status.
    public private(set) var authorizationStatus: MusicAuthorization.Status = .notDetermined

    /// Whether the user has authorized Apple Music.
    public var isAuthorized: Bool {
        authorizationStatus == .authorized
    }

    // MARK: - Authorization

    /// Requests Apple Music authorization.
    /// On first call, this opens the system authorization dialog.
    /// - Returns: The authorization status after the request.
    @discardableResult
    public func requestAuthorization() async -> MusicAuthorization.Status {
        let status = await MusicAuthorization.request()
        self.authorizationStatus = status
        self.isInitialized = true
        return status
    }

    /// Returns the current status without prompting.
    public func checkAuthorization() -> MusicAuthorization.Status {
        let status = MusicAuthorization.currentStatus
        self.authorizationStatus = status
        return status
    }

    // MARK: - Playback

    /// The currently playing song, if any.
    public var nowPlaying: Song? {
        player.queue.currentEntry?.item as? Song
    }

    /// The playback state.
    public var playbackState: MusicPlayer.PlaybackStatus {
        player.state.playbackStatus
    }

    /// Whether music is currently playing.
    public var isPlaying: Bool {
        playbackState == .playing
    }

    /// Current playback time in seconds.
    public var currentPlaybackTime: TimeInterval {
        player.playbackTime
    }

    /// Sets the queue to a single song and starts playback.
    public func play(song: Song) async throws {
        player.queue = [song]
        try await player.play()
    }

    /// Plays the current queue.
    public func play() async throws {
        try await player.play()
    }

    /// Pauses playback.
    public func pause() {
        player.pause()
    }

    /// Stops playback.
    public func stop() {
        player.stop()
    }

    /// Skips to the next entry.
    public func skipToNext() async throws {
        try await player.skipToNextEntry()
    }

    /// Skips to the previous entry.
    public func skipToPrevious() async throws {
        try await player.skipToPreviousEntry()
    }

    /// Seeks to a specific time.
    public func seek(to time: TimeInterval) async {
        player.playbackTime = time
    }

    // MARK: - Search

    /// Searches the Apple Music catalog for a song.
    public func search(
        title: String,
        artist: String
    ) async throws -> [Song] {
        var request = MusicCatalogSearchRequest(
            term: "\(title) \(artist)",
            types: [Song.self]
        )
        request.limit = 10

        let response = try await request.response()
        return response.songs.compactMap { $0 }
    }
}
