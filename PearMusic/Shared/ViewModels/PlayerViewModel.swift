import Foundation
import MusicKit
import Combine

// MARK: - Player View Model

/// Manages MusicKit player state and provides controls to SwiftUI views.
@Observable
public final class PlayerViewModel: Sendable {

    public static let shared = PlayerViewModel()

    private let playerManager = MusicPlayerManager.shared
    private let statePublisher = PlayerStatePublisher.shared

    // MARK: - State

    public var authorizationStatus: MusicAuthorization.Status = .notDetermined
    public var isPlaying: Bool = false
    public var currentTime: TimeInterval = 0
    public var duration: TimeInterval = 0

    public var nowPlayingTitle: String?
    public var nowPlayingArtist: String?
    public var nowPlayingAlbum: String?
    public var nowPlayingArtworkURL: URL?

    public var errorMessage: String?

    // MARK: - Authorization

    /// Returns whether MusicKit has been authorized.
    public var isAuthorized: Bool {
        authorizationStatus == .authorized
    }

    /// Requests authorization from the user.
    public func authorize() async {
        authorizationStatus = await playerManager.requestAuthorization()
        refreshState()
    }

    /// Checks authorization without prompting.
    public func checkAuthorization() {
        authorizationStatus = playerManager.checkAuthorization()
        refreshState()
    }

    // MARK: - Playback Controls

    public func play() async {
        do {
            try await playerManager.play()
            refreshState()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func pause() {
        playerManager.pause()
        refreshState()
    }

    public func skipToNext() async {
        do {
            try await playerManager.skipToNext()
            refreshState()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func skipToPrevious() async {
        do {
            try await playerManager.skipToPrevious()
            refreshState()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func seek(to time: TimeInterval) async {
        await playerManager.seek(to: time)
    }

    // MARK: - Play Song

    /// Searches Apple Music and plays the first matching song.
    public func searchAndPlay(title: String, artist: String) async {
        do {
            let songs = try await playerManager.search(title: title, artist: artist)
            guard let firstSong = songs.first else {
                errorMessage = "No results found for \"\(title)\""
                return
            }
            try await playerManager.play(song: firstSong)
            refreshState()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - State Refresh

    /// Refreshes all @Observable properties from the current player state.
    public func refreshState() {
        statePublisher.updateFromPlayer()
        isPlaying = statePublisher.isPlaying
        currentTime = statePublisher.currentTimeMs / 1000
        duration = statePublisher.durationMs / 1000
        nowPlayingTitle = statePublisher.nowPlayingTitle
        nowPlayingArtist = statePublisher.nowPlayingArtist
        nowPlayingAlbum = statePublisher.nowPlayingAlbum
        nowPlayingArtworkURL = statePublisher.nowPlayingArtworkURL
    }
}
