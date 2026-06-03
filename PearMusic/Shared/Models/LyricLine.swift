import Foundation

// MARK: - LyricLine

/// A single parsed lyric line with optional translation.
public struct LyricLine: Equatable, Hashable, Codable, Sendable {
    /// Timestamp in seconds from the start of the song.
    public let timestamp: TimeInterval

    /// Original lyric text (without timestamp).
    public let text: String

    /// Paired translation text, if available.
    public let translation: String?

    public init(timestamp: TimeInterval, text: String, translation: String? = nil) {
        self.timestamp = timestamp
        self.text = text
        self.translation = translation
    }
}

// MARK: - TimedWord

/// A single word with precise timing for karaoke-style rendering.
public struct TimedWord: Equatable, Hashable, Sendable {
    public let startTime: TimeInterval
    public let duration: TimeInterval
    public let text: String

    public init(startTime: TimeInterval, duration: TimeInterval, text: String) {
        self.startTime = startTime
        self.duration = duration
        self.text = text
    }
}

// MARK: - TimedLyricLine

/// A lyric line with word-level timing for karaoke-style highlight.
public struct TimedLyricLine: Equatable, Hashable, Sendable {
    public let timestamp: TimeInterval
    public let text: String
    public let translation: String?
    public let words: [TimedWord]

    public init(
        timestamp: TimeInterval,
        text: String,
        translation: String? = nil,
        words: [TimedWord] = []
    ) {
        self.timestamp = timestamp
        self.text = text
        self.translation = translation
        self.words = words
    }
}
