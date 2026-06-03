import Foundation
import MusicKit

// MARK: - Library Manager

/// Manages the user's Apple Music library: playlists, songs, recently played,
/// recommendations, and playlist CRUD operations.
///
/// All public methods are `@MainActor` because MusicKit library APIs are MainActor-isolated.
@MainActor
@Observable
public final class LibraryManager {

    public static let shared = LibraryManager()

    // MARK: - State

    public private(set) var playlists: [Playlist] = []
    public private(set) var recentlyPlayed: [RecentlyPlayedItem] = []
    public private(set) var recommendations: [MusicPersonalRecommendation] = []
    public private(set) var librarySongs: [Song] = []

    public private(set) var isLoadingPlaylists = false
    public private(set) var isLoadingRecentlyPlayed = false
    public private(set) var isLoadingRecommendations = false
    public private(set) var isLoadingSongs = false

    public var errorMessage: String?

    // MARK: - Playlist Fetching

    /// Fetches all user playlists from the library.
    @discardableResult
    public func fetchPlaylists() async throws -> [Playlist] {
        isLoadingPlaylists = true
        defer { isLoadingPlaylists = false }

        var request = MusicLibraryRequest<Playlist>()
        request.limit = 100  // Fetch up to 100 playlists

        let response = try await request.response()
        playlists = Array(response.items)
        return playlists
    }

    /// Fetches a specific playlist by ID.
    public func fetchPlaylist(id: MusicItemID) async throws -> Playlist {
        var request = MusicLibraryRequest<Playlist>()
        request.filter(matching: \.id, equalTo: id)

        let response = try await request.response()
        guard let playlist = response.items.first else {
            throw PearMusicError.playlistNotFound(id: id.rawValue)
        }
        return playlist
    }

    /// Fetches tracks within a playlist.
    public func fetchPlaylistTracks(playlist: Playlist) async throws -> [Track] {
        // Use MusicLibraryRequest to get the full playlist with tracks
        var request = MusicLibraryRequest<Playlist>()
        request.filter(matching: \.id, equalTo: playlist.id)

        let response = try await request.response()
        guard let fullPlaylist = response.items.first,
              let tracks = fullPlaylist.tracks else {
            return []
        }
        return Array(tracks)
    }

    // MARK: - Playlist Management

    /// Creates a new playlist in the user's library.
    public func createPlaylist(
        name: String,
        description: String = "",
        tracks: [Track] = []
    ) async throws -> Playlist {
        do {
            let playlist = try await MusicLibrary.shared.createPlaylist(
                name: name,
                description: description,
                items: tracks
            )
            // Refresh playlist list
            try? await fetchPlaylists()
            return playlist
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    /// Adds tracks to an existing playlist.
    public func addTracks(_ tracks: [Track], to playlist: Playlist) async throws {
        do {
            try await MusicLibrary.shared.edit(
                playlist,
                items: tracks,
                appendStrategy: .append
            )
        } catch {
            throw PearMusicError.trackAddFailed(
                songId: tracks.first?.id.rawValue ?? "unknown",
                playlistId: playlist.id.rawValue
            )
        }
    }

    /// Removes tracks from a playlist.
    public func removeTracks(_ tracks: [Track], from playlist: Playlist) async throws {
        do {
            try await MusicLibrary.shared.edit(
                playlist,
                items: tracks,
                appendStrategy: .remove
            )
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    /// Deletes a playlist from the library.
    public func deletePlaylist(_ playlist: Playlist) async throws {
        do {
            try await MusicLibrary.shared.delete(playlist)
            playlists.removeAll { $0.id == playlist.id }
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    // MARK: - Recently Played

    /// Fetches recently played items.
    @discardableResult
    public func fetchRecentlyPlayed() async throws -> [RecentlyPlayedItem] {
        isLoadingRecentlyPlayed = true
        defer { isLoadingRecentlyPlayed = false }

        var request = MusicRecentlyPlayedRequest<RecentlyPlayedItem>()
        request.limit = 25

        let response = try await request.response()
        recentlyPlayed = Array(response.items)
        return recentlyPlayed
    }

    // MARK: - Personal Recommendations

    /// Fetches "Made for You" and other personal recommendations.
    @discardableResult
    public func fetchRecommendations() async throws -> [MusicPersonalRecommendation] {
        isLoadingRecommendations = true
        defer { isLoadingRecommendations = false }

        var request = MusicPersonalRecommendationsRequest()
        request.limit = 25

        let response = try await request.response()
        recommendations = Array(response.recommendations)
        return recommendations
    }

    // MARK: - Library Songs

    /// Fetches all songs in the user's library.
    @discardableResult
    public func fetchLibrarySongs() async throws -> [Song] {
        isLoadingSongs = true
        defer { isLoadingSongs = false }

        var request = MusicLibraryRequest<Song>()
        request.limit = 200

        let response = try await request.response()
        librarySongs = Array(response.items)
        return librarySongs
    }

    /// Checks whether a song is in the user's library.
    public func isSongInLibrary(_ song: Song) -> Bool {
        librarySongs.contains { $0.id == song.id }
    }

    /// Adds a song to the library.
    public func addToLibrary(_ song: Song) async throws {
        do {
            try await MusicLibrary.shared.add(song)
            librarySongs.append(song)
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    /// Removes a song from the library.
    public func removeFromLibrary(_ song: Song) async throws {
        do {
            try await MusicLibrary.shared.delete(song)
            librarySongs.removeAll { $0.id == song.id }
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    // MARK: - Refresh All

    /// Refreshes all library data in parallel.
    public func refreshAll() async {
        async let playlistsTask: () = fetchPlaylists()
        async let recentTask: () = fetchRecentlyPlayed()
        async let recsTask: () = fetchRecommendations()
        async let songsTask: () = fetchLibrarySongs()

        do {
            _ = try await (playlistsTask, recentTask, recsTask, songsTask)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Init

    private init() {}
}
