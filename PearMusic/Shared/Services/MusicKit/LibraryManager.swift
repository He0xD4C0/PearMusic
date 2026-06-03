import Foundation
import MusicKit

// MARK: - Library Manager

/// Manages the user's Apple Music library: playlists, songs,
/// and playlist CRUD operations.
///
/// All public methods are `@MainActor` because MusicKit library APIs are MainActor-isolated.
@MainActor
@Observable
public final class LibraryManager {

    public static let shared = LibraryManager()

    // MARK: - State

    public private(set) var playlists: [Playlist] = []
    public private(set) var librarySongs: [Song] = []

    public private(set) var isLoadingPlaylists = false
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

    /// Creates a new playlist in the user's library. iOS only.
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

    /// Adds tracks to an existing playlist by rebuilding it with appended items. iOS only.
    public func addTracks(_ tracks: [Track], to playlist: Playlist) async throws {
        #if os(iOS)
        do {
            let playlistWithTracks = try await fetchPlaylist(id: playlist.id)
            let existingTracks = playlistWithTracks.tracks ?? MusicItemCollection<Track>([])
            var allTracks = Array(existingTracks)
            allTracks.append(contentsOf: tracks)

            _ = try await MusicLibrary.shared.createPlaylist(
                name: playlistWithTracks.name,
                description: "",
                items: allTracks
            )
            try await MusicLibrary.shared.delete(playlist)
            _ = try? await fetchPlaylists()
        } catch {
            throw PearMusicError.trackAddFailed(
                songId: tracks.first?.id.rawValue ?? "unknown",
                playlistId: playlist.id.rawValue
            )
        }
        #else
        throw PearMusicError.playlistEditFailed(
            underlying: PearMusicError.unknown(underlying:
                NSError(domain: "PearMusic", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Playlist editing is only available on iOS."])
            )
        )
        #endif
    }

    /// Removes tracks from a playlist. iOS only.
    public func removeTracks(_ tracks: [Track], from playlist: Playlist) async throws {
        #if os(iOS)
        do {
            let trackIDs = Set(tracks.map(\.id))
            let playlistWithTracks = try await fetchPlaylist(id: playlist.id)
            let existingTracks = playlistWithTracks.tracks ?? MusicItemCollection<Track>([])
            let filtered = Array(existingTracks).filter { !trackIDs.contains($0.id) }

            _ = try await MusicLibrary.shared.createPlaylist(
                name: playlistWithTracks.name,
                description: "",
                items: filtered
            )
            try await MusicLibrary.shared.delete(playlist)
            _ = try? await fetchPlaylists()
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
        #else
        throw PearMusicError.playlistEditFailed(
            underlying: PearMusicError.unknown(underlying:
                NSError(domain: "PearMusic", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Playlist editing is only available on iOS."])
            )
        )
        #endif
    }

    /// Deletes a playlist from the library.
    public func deletePlaylist(_ playlist: Playlist) async throws {
        do {
            #if os(iOS)
            try await MusicLibrary.shared.delete(playlist)
            #endif
            playlists.removeAll { $0.id == playlist.id }
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
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

    /// Adds a song to the library. iOS only.
    public func addToLibrary(_ song: Song) async throws {
        #if os(iOS)
        do {
            try await MusicLibrary.shared.add(song)
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
        #endif
        librarySongs.append(song)
    }

    /// Removes a song from the library.
    public func removeFromLibrary(_ song: Song) async throws {
        #if os(iOS)
        do {
            try await MusicLibrary.shared.delete(song)
        } catch {
            throw PearMusicError.playlistEditFailed(underlying: error)
        }
        #endif
        librarySongs.removeAll { $0.id == song.id }
    }

    // MARK: - Refresh All

    /// Refreshes all library data.
    public func refreshAll() async {
        do {
            try await fetchPlaylists()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }

        do {
            try await fetchLibrarySongs()
        } catch {
            // Silently degrade — songs are non-critical
        }
    }

    // MARK: - Init

    private init() {}
}
