import Foundation
import MusicKit

// MARK: - Search View Model

/// Manages Apple Music catalog search state for SwiftUI views.
@MainActor
@Observable
public final class SearchViewModel {

    // MARK: - Dependencies

    private let engine = PlaybackEngine.shared

    // MARK: - State

    public var query: String = ""
    public var results: [Song] = []
    public var isSearching: Bool = false
    public var hasSearched: Bool = false
    public var errorMessage: String?

    /// Recent successful searches for quick re-query.
    public var recentSearches: [String] = []

    // MARK: - Actions

    /// Performs a catalog search with the current query.
    public func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            results = []
            hasSearched = false
            return
        }

        isSearching = true
        hasSearched = true
        errorMessage = nil

        do {
            let songs = try await engine.search(query: trimmed, limit: 25)
            results = songs

            if !songs.isEmpty {
                recentSearches.insert(trimmed, at: 0)
                // Keep max 10 recent searches, deduplicated
                recentSearches = Array(NSOrderedSet(array: recentSearches).prefix(10)) as? [String] ?? []
            }
        } catch {
            errorMessage = error.localizedDescription
            results = []
        }

        isSearching = false
    }

    /// Performs a search with an explicit query string.
    public func search(term: String) async {
        query = term
        await search()
    }

    /// Clears search state.
    public func clear() {
        query = ""
        results = []
        hasSearched = false
        errorMessage = nil
    }

    /// Plays a song from search results.
    public func playSong(_ song: Song) async throws {
        try await engine.play(song: song)
    }

    /// Plays the entire search results as a queue.
    public func playAllResults() async throws {
        guard !results.isEmpty else {
            throw PearMusicError.queueEmpty
        }
        try await engine.play(songs: results)
    }

    /// Adds a song to the queue.
    public func addToQueue(_ song: Song) {
        engine.addToQueue(song)
    }

    /// Plays a song immediately after the current track.
    public func playNext(_ song: Song) {
        engine.playNext(song)
    }

    // MARK: - Init

    public init() {}
}
