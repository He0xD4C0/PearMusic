import Foundation

// MARK: - Lyric Service

/// Fetches song lyrics from the NetEase Cloud Music IoT Open Platform.
public final class NeteaseLyricService: Sendable {
    private let httpClient: NeteaseHTTPClient

    public init(httpClient: NeteaseHTTPClient) {
        self.httpClient = httpClient
    }

    // MARK: - Public API

    /// Fetches line-by-line lyrics for a song.
    public func getLyric(songId: String) async throws -> NeteaseLyricResponse {
        let bizContent = #"{"songId":"\#(songId)"}"#

        return try await httpClient.get(
            path: "/openapi/music/basic/song/lyric/get/v2",
            bizContent: bizContent
        )
    }

    /// Fetches word-by-word lyrics (karaoke mode, ~4M hot songs only).
    public func getWordLyric(songId: String) async throws -> WordLyricResponse? {
        let bizContent = #"{"songId":"\#(songId)"}"#

        let response: WordLyricResponse = try await httpClient.get(
            path: "/openapi/music/basic/song/lyric/word/by/word/get",
            bizContent: bizContent
        )

        guard response.code == 200, response.data?.content != nil else {
            return nil
        }
        return response
    }

    /// Fetches both line-by-line and word-by-word lyrics.
    public func fetchAll(
        songId: String
    ) async throws -> (lyric: NeteaseLyricResponse, word: WordLyricResponse?) {
        async let lyric = getLyric(songId: songId)
        async let word = getWordLyric(songId: songId)

        return try await (lyric: lyric, word: word)
    }
}
