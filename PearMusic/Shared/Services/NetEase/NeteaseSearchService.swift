import Foundation

// MARK: - Search Service

/// Searches NetEase for songs matching Apple Music track metadata.
/// Uses fuzzy string matching for high hit rates on foreign titles.
public final class NeteaseSearchService: Sendable {
    private let httpClient: NeteaseHTTPClient

    public init(httpClient: NeteaseHTTPClient) {
        self.httpClient = httpClient
    }

    // MARK: - Public API

    /// Searches for a song by artist and title.
    public func search(
        artist: String,
        song: String,
        pageSize: Int = 20
    ) async throws -> [SearchResultSong] {
        let bizContent = """
        {"artist":"\(escapeJSON(artist))","song":"\(escapeJSON(song))","pageNo":1,"pageSize":\(pageSize)}
        """

        let response: NeteaseSearchResponse = try await httpClient.get(
            path: "/openapi/music/basic/search/song/by/artist/song/get/v2",
            bizContent: bizContent
        )

        if response.code != 200 {
            throw NeteaseAPIError(code: response.code, message: response.msg)
        }

        return response.data?.songs ?? []
    }

    /// Finds the best-matching encrypted songId for a given track.
    /// Returns nil if no match exceeds the confidence threshold.
    public func findBestMatch(
        artist: String,
        song: String,
        threshold: Double = 0.6
    ) async throws -> String? {
        let candidates = try await search(artist: artist, song: song)

        guard !candidates.isEmpty else { return nil }

        let matchCandidates = candidates.map {
            StringSimilarity.MatchCandidate(
                id: $0.songId,
                songName: $0.songName,
                artistName: $0.artistName
            )
        }

        let scored = StringSimilarity.scoreMatches(
            querySong: song,
            queryArtist: artist,
            candidates: matchCandidates
        )

        guard let best = scored.first, best.score >= threshold else {
            return nil
        }

        return best.candidate.id
    }

    // MARK: - Private

    private func escapeJSON(_ s: String) -> String {
        s.replacingOccurrences(of: "\\", with: "\\\\")
         .replacingOccurrences(of: "\"", with: "\\\"")
         .replacingOccurrences(of: "\n", with: "\\n")
    }
}
