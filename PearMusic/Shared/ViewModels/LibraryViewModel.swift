import Foundation
import MusicKit

// MARK: - Library View Model

/// Manages library state for SwiftUI views: playlists, songs,
/// recently played, and recommendations.
@MainActor
@Observable
public final class LibraryViewModel {

    public static let shared = LibraryViewModel()

    // MARK: - Dependencies

    private let library = LibraryManager.shared
    private let downloads = DownloadProvider.shared
    private let engine = PlaybackEngine.shared

    // MARK: - State

    public var playlists: [Playlist] { library.playlists }
    public var recentlyPlayed: [RecentlyPlayedItem] { library.recentlyPlayed }
    public var recommendations: [MusicPersonalRecommendation] { library.recommendations }
    public var librarySongs: [Song] {
        downloads.filterDownloaded(library.librarySongs)
    }

    public var isLoading: Bool {
        library.isLoadingPlaylists
        || library.isLoadingRecentlyPlayed
        || library.isLoadingSongs
    }

    public var errorMessage: String? { library.errorMessage }

    // MARK: - Offline

    public var offlineMode: Bool {
        get { downloads.offlineMode }
        set { downloads.offlineMode = newValue }
    }

    // MARK: - Actions

    public func refreshAll() async {
        await library.refreshAll()
    }

    public func fetchPlaylists() async throws {
        try await library.fetchPlaylists()
    }

    public func fetchRecentlyPlayed() async throws {
        try await library.fetchRecentlyPlayed()
    }

    public func fetchRecommendations() async throws {
        try await library.fetchRecommendations()
    }

    public func fetchLibrarySongs() async throws {
        try await library.fetchLibrarySongs()
    }

    public func createPlaylist(name: String, description: String = "") async throws -> Playlist {
        try await library.createPlaylist(name: name, description: description)
    }

    public func deletePlaylist(_ playlist: Playlist) async throws {
        try await library.deletePlaylist(playlist)
    }

    public func playPlaylist(_ playlist: Playlist) async throws {
        let fullPlaylist = try await library.fetchPlaylist(id: playlist.id)
        guard let tracks = fullPlaylist.tracks else {
            throw PearMusicError.queueEmpty
        }
        let songs = tracks.compactMap { track -> Song? in
            if case .song(let song) = track {
                return song
            }
            return nil
        }
        try await engine.play(songs: songs)
    }

    public func playSong(_ song: Song) async throws {
        try await engine.play(song: song)
    }

    public func addSongToLibrary(_ song: Song) async throws {
        try await library.addToLibrary(song)
    }

    public func removeSongFromLibrary(_ song: Song) async throws {
        try await library.removeFromLibrary(song)
    }

    public func isInLibrary(_ song: Song) -> Bool {
        library.isSongInLibrary(song)
    }

    public func downloadSong(_ song: Song) async throws {
        try await downloads.requestDownload(for: song)
    }

    public func isDownloaded(_ song: Song) -> Bool {
        downloads.status(for: song) == .downloaded
    }

    public func toggleOfflineMode() {
        downloads.toggleOfflineMode()
    }

    // MARK: - Init

    private init() {}
}
