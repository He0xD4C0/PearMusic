import Foundation
import Combine
import MusicKit

// MARK: - Player State Publisher

/// Reactive player state using Combine.
/// Provides a stream of player state snapshots for SwiftUI views.
@Observable
public final class PlayerStatePublisher {

    public static let shared = PlayerStatePublisher()

    // MARK: - Published State

    public var isAuthorized: Bool = false
    public var isPlaying: Bool = false
    public var currentTimeMs: Double = 0
    public var durationMs: Double = 0

    public var nowPlayingTitle: String?
    public var nowPlayingArtist: String?
    public var nowPlayingAlbum: String?
    public var nowPlayingArtworkURL: URL?
    public var nowPlayingSongID: String?

    // MARK: - Update

    /// Updates state from the current MusicPlayerManager snapshot.
    public func updateFromPlayer() {
        let manager = MusicPlayerManager.shared

        isAuthorized = manager.isAuthorized
        isPlaying = manager.isPlaying
        currentTimeMs = manager.currentPlaybackTime * 1000

        if let song = manager.nowPlaying {
            nowPlayingTitle = song.title
            nowPlayingArtist = song.artistName
            nowPlayingAlbum = song.albumTitle
            nowPlayingSongID = song.id.rawValue

            if let artwork = song.artwork {
                nowPlayingArtworkURL = artwork.url(
                    width: 300,
                    height: 300
                )
            }
            durationMs = (song.duration ?? 0) * 1000
        } else {
            nowPlayingTitle = nil
            nowPlayingArtist = nil
            nowPlayingAlbum = nil
            nowPlayingArtworkURL = nil
            nowPlayingSongID = nil
            durationMs = 0
        }
    }

    /// Called on song change — resets lyric-related state.
    public func resetForNewSong() {
        currentTimeMs = 0
        durationMs = 0
    }
}
