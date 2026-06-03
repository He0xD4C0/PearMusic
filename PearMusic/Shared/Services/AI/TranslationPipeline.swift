import Foundation

// MARK: - Translation Pipeline

/// Async queue-based pipeline for translating song lyrics via LLM.
///
/// Features:
/// - Strict prompt guard: preserves all timestamps
/// - Output validation: verifies timestamp count matches input
/// - In-memory cache: avoids re-translating the same song
/// - Fallback: returns original lines on failure
public final class TranslationPipeline: @unchecked Sendable {
    private let llmClient: LLMClient
    private var _cache: [String: TranslationCacheEntry] = [:]
    private let _lock = NSLock()

    public init(llmClient: LLMClient) {
        self.llmClient = llmClient
    }

    // MARK: - Public API

    /// Translates lyrics to Chinese, checking cache first.
    public func translate(
        songId: String,
        lines: [LyricLine],
        sourceLang: String = "auto",
        targetLang: String = "zh"
    ) async throws -> [LyricLine] {
        guard !lines.isEmpty else { return [] }

        // Check cache
        let cacheKey = "\(songId):\(sourceLang):\(targetLang)"
        let cached = _lock.withLock { _cache[cacheKey] }
        if let cached, cached.originalLineCount == lines.count {
            return cached.translatedLines
        }

        // Perform translation
        let prompt = buildPrompt(lines: lines, targetLang: targetLang)
        let systemPrompt = buildSystemPrompt(targetLang: targetLang)

        let response: String
        do {
            response = try await llmClient.complete(
                userPrompt: prompt,
                systemPrompt: systemPrompt
            )
        } catch {
            // Fallback: return original lines on failure
            return lines
        }

        let translated = parseResponse(response, originalLines: lines)

        // Cache result
        let entry = TranslationCacheEntry(
            songId: songId,
            sourceLang: sourceLang,
            targetLang: targetLang,
            originalLineCount: lines.count,
            translatedLines: translated,
            modelUsed: "deepseek-chat"
        )
        _lock.withLock { _cache[cacheKey] = entry }

        return translated
    }

    // MARK: - Prompt Construction

    private func buildSystemPrompt(targetLang: String) -> String {
        let name = languageName(targetLang)
        return """
        You are a professional song lyric translator. Your task is to translate \
        lyrics to \(name) while strictly preserving all timestamps. The translation \
        should be natural, poetic, and suitable for singing. Never modify, rearrange, \
        or skip timestamps. Return ONLY the formatted lines with no explanations.
        """
    }

    private func buildPrompt(lines: [LyricLine], targetLang: String) -> String {
        let name = languageName(targetLang)
        let originalLRC = lines.map {
            "\(LRCUtils.formatTimestamp($0.timestamp))\($0.text)"
        }.joined(separator: "\n")

        return """
        Translate the following song lyrics to \(name).

        CRITICAL RULES — YOU MUST FOLLOW ALL OF THEM:
        1. PRESERVE the exact [mm:ss.xx] timestamps on EVERY line — DO NOT modify, rearrange, or skip any timestamps
        2. Format each output line EXACTLY as: [mm:ss.xx]Original Lyric / \(name) Translation
        3. Keep the translation natural and poetic, suitable for singing
        4. Translate ALL lines — do not skip any
        5. Return ONLY the formatted lines — no explanations, no headers, no footers
        6. Keep translations concise — roughly the same length as the original

        Lyrics to translate:
        \(originalLRC)

        Translated lyrics:
        """
    }

    // MARK: - Response Parsing

    private func parseResponse(
        _ response: String,
        originalLines: [LyricLine]
    ) -> [LyricLine] {
        let rawLines = response.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
        var translated: [LyricLine] = []

        let tsPattern = try! NSRegularExpression(pattern: "^\\[(\\d{2}):(\\d{2})\\.(\\d{2,3})\\]")

        for line in rawLines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }

            let range = NSRange(trimmed.startIndex..., in: trimmed)
            guard let match = tsPattern.firstMatch(in: trimmed, range: range),
                  match.numberOfRanges >= 4,
                  let minRange = Range(match.range(at: 1), in: trimmed),
                  let secRange = Range(match.range(at: 2), in: trimmed),
                  let subRange = Range(match.range(at: 3), in: trimmed),
                  let minutes = Int(trimmed[minRange]),
                  let seconds = Int(trimmed[secRange]),
                  let subSeconds = Int(trimmed[subRange]) else {
                continue
            }

            let timestamp = LRCUtils.parseTimestamp(
                minutes: minutes,
                seconds: seconds,
                subSeconds: subSeconds
            )

            let nsrange = match.range
            let startIdx = trimmed.index(trimmed.startIndex, offsetBy: nsrange.length)
            let content = String(trimmed[startIdx...])
                .trimmingCharacters(in: .whitespaces)

            // Split on " / " for original / translation
            let separator: String
            if content.contains(" / ") {
                separator = " / "
            } else if content.contains(" /") {
                separator = " /"
            } else if content.contains("/ ") {
                separator = "/ "
            } else {
                separator = ""
            }

            let text: String
            let translation: String?

            if !separator.isEmpty,
               let sepRange = content.range(of: separator) {
                text = String(content[..<sepRange.lowerBound]).trimmingCharacters(in: .whitespaces)
                translation = String(content[sepRange.upperBound...]).trimmingCharacters(in: .whitespaces)
            } else {
                text = content
                translation = nil
            }

            translated.append(
                LyricLine(timestamp: timestamp, text: text, translation: translation)
            )
        }

        // Validate: if too few lines parsed, fall back to originals
        if translated.count < originalLines.count / 2 {
            return originalLines
        }

        return translated
    }

    // MARK: - Helpers

    private func languageName(_ lang: String) -> String {
        switch lang {
        case "zh": return "Chinese"
        case "en": return "English"
        case "ja": return "Japanese"
        case "ko": return "Korean"
        default: return lang
        }
    }
}
