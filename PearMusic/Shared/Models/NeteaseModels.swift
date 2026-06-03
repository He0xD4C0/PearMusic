import Foundation

// MARK: - Device Configuration

public struct NeteaseDeviceConfig: Codable, Sendable {
    public let deviceType: String
    public let os: String
    public let appVer: String
    public let channel: String
    public let model: String
    public let deviceId: String
    public let brand: String
    public let osVer: String
    public let clientIp: String

    public init(
        deviceType: String = "openapi",
        os: String = "macos",
        appVer: String = "1.0.0",
        channel: String = "pearmusic",
        model: String = "mac",
        deviceId: String,
        brand: String = "pearmusic",
        osVer: String = "14.0",
        clientIp: String = "0.0.0.0"
    ) {
        self.deviceType = deviceType
        self.os = os
        self.appVer = appVer
        self.channel = channel
        self.model = model
        self.deviceId = deviceId
        self.brand = brand
        self.osVer = osVer
        self.clientIp = clientIp
    }

    public func toJSON() -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }
}

// MARK: - Anonymous Login

public struct AnonymousLoginResponse: Codable, Sendable {
    public let code: Int
    public let msg: String
    public let data: TokenData?

    public struct TokenData: Codable, Sendable {
        public let accessToken: String
        public let expiresIn: Int?
        public let refreshToken: String?
        public let userId: String?
    }
}

// MARK: - Search

public struct NeteaseSearchResponse: Codable, Sendable {
    public let code: Int
    public let msg: String
    public let data: SearchData?

    public struct SearchData: Codable, Sendable {
        public let songs: [SearchResultSong]
        public let total: Int
        public let hasMore: Bool
    }
}

public struct SearchResultSong: Codable, Sendable, Identifiable {
    public let songId: String
    public let songName: String
    public let artistName: String
    public let albumName: String
    public let albumId: String
    /// Duration in milliseconds.
    public let duration: Int
    public let playFlag: Bool?
    public let songFee: Int?

    public var id: String { songId }
}

// MARK: - Lyric

public struct NeteaseLyricResponse: Codable, Sendable {
    public let code: Int
    public let msg: String
    public let data: LyricData?

    public struct LyricData: Codable, Sendable {
        public let songId: String
        /// true = instrumental / pure music.
        public let noLyric: Bool
        /// Raw LRC-formatted lyrics, or null.
        public let lyric: String?
        /// Raw LRC-formatted bilingual translation, or null.
        public let transLyric: String?
        /// Lyric version number.
        public let lyricVersion: Int
    }
}

// MARK: - Word-by-Word Lyric

public struct WordLyricResponse: Codable, Sendable {
    public let code: Int
    public let msg: String
    public let data: WordData?

    public struct WordData: Codable, Sendable {
        public let songId: String
        public let content: [WordLyricLine]?
    }
}

public struct WordLyricLine: Codable, Sendable, Identifiable {
    public let startTime: Int   // milliseconds
    public let content: String
    public let words: [LyricWord]

    public var id: Int { startTime.hashValue ^ content.hashValue }
}

public struct LyricWord: Codable, Sendable {
    public let startTime: Int   // milliseconds
    public let duration: Int    // milliseconds
    public let text: String
}

// MARK: - Error Codes

public enum NeteaseErrorCode: Int, Sendable {
    case success = 200
    case tokenExpired = 1406
    case tokenInvalid = 1408
    case accountNotFound = 1407
}

// MARK: - API Error

public struct NeteaseAPIError: Error, LocalizedError {
    public let code: Int
    public let message: String

    public var errorDescription: String? {
        "[Netease API] [\(code)] \(message)"
    }

    public var isAuthError: Bool {
        code == NeteaseErrorCode.tokenExpired.rawValue
        || code == NeteaseErrorCode.tokenInvalid.rawValue
    }
}
