import Foundation

// MARK: - Lyric State Machine

/// The complete state space for lyric rendering.
public enum LyricState: Equatable, Sendable {
    /// No song is playing, nothing to display.
    case idle

    /// Searching for lyrics or fetching from API.
    case loading

    /// Instrumental / pure music — lyrics don't exist.
    case noLyric

    /// Lyrics exist in theory but the API returned nothing.
    case unavailable

    /// Has official bilingual lyrics (lyric + transLyric both present).
    case native(lines: [LyricLine])

    /// Has original lyrics only, no official translation.
    case nativeOriginal(lines: [LyricLine])

    /// AI translation is in progress, show original lines.
    case aiTranslating(originalLines: [LyricLine])

    /// AI translation completed, show bilingual lines.
    case aiTranslated(lines: [LyricLine])

    /// Has word-level timing data (karaoke mode).
    case wordTimed(lines: [TimedLyricLine])

    /// An error occurred during lyric fetch or translation.
    case error(message: String)

    // MARK: - Helpers

    /// Returns the lyric lines if the current state has them.
    public var lines: [LyricLine]? {
        switch self {
        case .native(let lines),
             .nativeOriginal(let lines),
             .aiTranslated(let lines):
            return lines
        case .aiTranslating(let originalLines):
            return originalLines
        case .wordTimed(let timedLines):
            // Map TimedLyricLine to LyricLine for compatibility
            return timedLines.map {
                LyricLine(timestamp: $0.timestamp, text: $0.text, translation: $0.translation)
            }
        default:
            return nil
        }
    }

    /// Whether the lyrics should scroll/sync to playback.
    public var shouldSync: Bool {
        switch self {
        case .native, .nativeOriginal, .aiTranslating, .aiTranslated, .wordTimed:
            return true
        default:
            return false
        }
    }

    /// Whether AI translation can be triggered.
    public var canTranslate: Bool {
        if case .nativeOriginal = self { return true }
        return false
    }

    /// Whether translation is in progress.
    public var isTranslating: Bool {
        if case .aiTranslating = self { return true }
        return false
    }
}
