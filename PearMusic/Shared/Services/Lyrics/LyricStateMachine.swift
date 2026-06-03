import Foundation

// MARK: - Lyric State Machine

/// Implements the lyric decision tree:
/// Fetch → noLyric? → lyric==nil? → transLyric? → AI? → Render
@Observable
public final class LyricStateMachine {

    public private(set) var state: LyricState = .idle

    public init() {}

    // MARK: - Main Processing

    /// Processes a full lyric API response and transitions the state accordingly.
    @discardableResult
    public func process(
        noLyric: Bool,
        lyric: String?,
        transLyric: String?
    ) -> LyricState {
        state = .loading

        if noLyric {
            state = .noLyric
            return state
        }

        guard let lyricStr = lyric, !lyricStr.trimmingCharacters(in: .whitespaces).isEmpty else {
            state = .unavailable
            return state
        }

        if let transStr = transLyric, !transStr.trimmingCharacters(in: .whitespaces).isEmpty {
            // Has bilingual translation
            let merged = LRCParser.merge(
                originalLRC: lyricStr,
                translationLRC: transStr
            )
            state = .native(lines: merged)
            return state
        }

        // Original only — AI translation can be triggered later
        let lines = LRCParser.parseLinesOnly(lyricStr)
        state = .nativeOriginal(lines: lines)
        return state
    }

    // MARK: - AI Translation

    /// Triggers AI translation. Caller should run the pipeline and call completeAITranslation.
    /// Returns the original lines to translate, or nil if not in the right state.
    public func triggerAITranslation() -> [LyricLine]? {
        guard case .nativeOriginal(let lines) = state else {
            return nil
        }
        state = .aiTranslating(originalLines: lines)
        return lines
    }

    /// Completes the AI translation with the translated lines.
    public func completeAITranslation(lines: [LyricLine]) {
        state = .aiTranslated(lines: lines)
    }

    /// Handles an error during translation.
    public func failTranslation(message: String) {
        state = .error(message: message)
    }

    // MARK: - Word Timing

    /// Processes word-level timing data (karaoke mode).
    public func processWordLyric(_ wordLyricLines: [WordLyricLine]) {
        let timedLines = WordLyricParser.parse(wordLyricLines)
        state = .wordTimed(lines: timedLines)
    }

    // MARK: - Helpers

    /// Resets to idle.
    public func reset() {
        state = .idle
    }

    /// Returns the current lines if available.
    public var lines: [LyricLine]? {
        state.lines
    }

    /// Whether lyrics should be synchronized to playback.
    public var shouldSync: Bool {
        state.shouldSync
    }

    /// Whether AI translation can be triggered.
    public var canTranslate: Bool {
        state.canTranslate
    }
}
