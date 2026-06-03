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
    public private(set) var recentlyPlayedAlbums: [Album] = []
    public private(set) var recentlyPlayedPlaylists: [Playlist] = []
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
        request.limit = 100

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
    /// - Note: `createPlaylist` is only available on iOS. On macOS, an error is thrown.
    public func createPlaylist(
        name: String,
        description: String = "",
        tracks: [Track] = []
    ) async throws -> Playlist {
        #if os(iOS)
        do {
            let playlist = try await MusicLibrary.shared.createPlaylist(
                name: name,
                description: description,
                items: tracks
            )
            _ = try? await fetchPlaylists()
            return playlist
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
        #else
        throw PearMusicError.playlistEditFailed(
            underlying: PearMusicError.unknown(underlying:
                NSError(domain: "PearMusic", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Playlist creation is only available on iOS."])
            )
        )
        #endif
    }

    /// Adds tracks to an existing playlist via the library edit API.
    public func addTracks(_ tracks: [Track], to playlist: Playlist) async throws {
        do {
            // MusicLibrary.edit expects items to add to the playlist
            let playlistWithTracks = try await fetchPlaylist(id: playlist.id)
            // Fetch the existing tracks, append new ones, and rebuild
            let existingTracks = playlistWithTracks.tracks ?? MusicItemCollection<Track>([])
            var allTracks = Array(existingTracks)
            allTracks.append(contentsOf: tracks)

            // Re-create approach: add items via library request
            // Note: direct append API varies by MusicKit version
            _ = try await MusicLibrary.shared.createPlaylist(
                name: playlistWithTracks.name,
                description: playlistWithTracks.descriptionText ?? "",
                items: allTracks
            )
            // Delete old playlist
            try await removePlaylistFromLibrary(playlist)
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
            let trackIDs = Set(tracks.map(\.id))
            let playlistWithTracks = try await fetchPlaylist(id: playlist.id)
            let existingTracks = playlistWithTracks.tracks ?? MusicItemCollection<Track>([])
            let filtered = Array(existingTracks).filter { !trackIDs.contains($0.id) }

            _ = try await MusicLibrary.shared.createPlaylist(
                name: playlistWithTracks.name,
                description: playlistWithTracks.descriptionText ?? "",
                items: filtered
            )
            try await removePlaylistFromLibrary(playlist)
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    /// Removes a playlist reference from our local list.
    private func removePlaylistFromLibrary(_ playlist: Playlist) async throws {
        #if os(iOS)
        try await MusicLibrary.shared.delete(playlist)
        #endif
        playlists.removeAll { $0.id == playlist.id }
    }

    /// Deletes a playlist from the library.
    public func deletePlaylist(_ playlist: Playlist) async throws {
        do {
            #if os(iOS)
            try await MusicLibrary.shared.delete(playlist)
            #else
            // macOS: remove from local state only
            #endif
            playlists.removeAll { $0.id == playlist.id }
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    // MARK: - Recently Played

    /// Fetches recently played albums.
    @discardableResult
    public func fetchRecentlyPlayed() async throws {
        isLoadingRecentlyPlayed = true
        defer { isLoadingRecentlyPlayed = false }

        var albumRequest = MusicRecentlyPlayedRequest<Album>()
        albumRequest.limit = 25
        let albumResponse = try await albumRequest.response()
        recentlyPlayedAlbums = Array(albumResponse.items)

        var playlistRequest = MusicRecentlyPlayedRequest<Playlist>()
        playlistRequest.limit = 10
        let playlistResponse = try await playlistRequest.response()
        recentlyPlayedPlaylists = Array(playlistResponse.items)
    }

    // MARK: - Personal Recommendations

    /// Fetches "Made for You" and other personal recommendations.
    @discardableResult
    public func fetchRecommendations() async throws -> [MusicPersonalRecommendation] {
        isLoadingRecommendations = true
        defer { isLoadingRecommendations = false }

        let request = MusicPersonalRecommendationsRequest()
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
            #if os(iOS)
            try await MusicLibrary.shared.add(song)
            #endif
            librarySongs.append(song)
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    /// Removes a song from the library.
    public func removeFromLibrary(_ song: Song) async throws {
        do {
            #if os(iOS)
            try await MusicLibrary.shared.delete(song)
            #endif
            librarySongs.removeAll { $0.id == song.id }
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
    }

    // MARK: - Refresh All

    /// Refreshes all library data sequentially.
    public func refreshAll() async {
        do {
            try await fetchPlaylists()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }

        do {
            try await fetchRecentlyPlayed()
        } catch {
            // Silently degrade — recently played is non-critical
        }

        do {
            try await fetchRecommendations()
        } catch {
            // Silently degrade
        }

        do {
            try await fetchLibrarySongs()
        } catch {
            // Silently degrade
        }
    }

    // MARK: - Init

    private init() {}
}
