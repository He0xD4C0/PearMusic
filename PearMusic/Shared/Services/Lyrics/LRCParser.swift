import Foundation

// MARK: - LRC Parser

/// Full LRC (LyRiCs) format parser supporting:
/// - Standard timestamps: [mm:ss.xx] or [mm:ss.xxx]
/// - Multi-timestamp lines: [01:23.45][01:56.78]Same text
/// - Offset tags: [offset:+1500]
/// - ID/metadata tags: [ti:Title], [ar:Artist], [al:Album], [by:Author]
/// - Bilingual split: "Original / Translation"
public enum LRCParser {

    // MARK: - Timestamp Regex

    private static let timestampPattern = try! NSRegularExpression(
        pattern: "\\[(\\d{2}):(\\d{2})\\.(\\d{2,3})\\]"
    )

    private static let offsetPattern = try! NSRegularExpression(
        pattern: "\\[offset:([+-]?\\d+)\\]",
        options: .caseInsensitive
    )

    private static let tagPattern = try! NSRegularExpression(
        pattern: "\\[(ti|ar|al|by|length):(.+)\\]",
        options: .caseInsensitive
    )

    // MARK: - Parse

    /// Parses a raw LRC string into lyric lines and metadata.
    public static func parse(_ lrcString: String) -> (lines: [LyricLine], offsetMs: Int) {
        guard !lrcString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return ([], 0)
        }

        let rawLines = lrcString.components(separatedBy: "\n")
        let offsetMs = parseOffset(from: rawLines)
        let lines = parseLyricLines(rawLines, offsetMs: offsetMs)

        return (lines, offsetMs)
    }

    /// Parses only lyric lines (no metadata), with optional offset.
    public static func parseLinesOnly(_ lrcString: String) -> [LyricLine] {
        guard !lrcString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return []
        }

        let rawLines = lrcString.components(separatedBy: "\n")
        let offsetMs = parseOffset(from: rawLines)
        return parseLyricLines(rawLines, offsetMs: offsetMs)
    }

    // MARK: - Bilingual Merge

    /// Merges original lyrics with a translation LRC by matching timestamps.
    public static func merge(
        originalLRC: String,
        translationLRC: String
    ) -> [LyricLine] {
        let originalLines = parseLinesOnly(originalLRC)
        let translationLines = parseLinesOnly(translationLRC)

        var translationMap: [TimeInterval: String] = [:]
        for line in translationLines {
            translationMap[line.timestamp] = line.text
        }

        return originalLines.map { line in
            LyricLine(
                timestamp: line.timestamp,
                text: line.text,
                translation: translationMap[line.timestamp]
            )
        }
    }

    // MARK: - Private

    private static func parseOffset(from rawLines: [String]) -> Int {
        for line in rawLines {
            let range = NSRange(line.startIndex..., in: line)
            if let match = offsetPattern.firstMatch(in: line, range: range),
               match.numberOfRanges >= 2,
               let valueRange = Range(match.range(at: 1), in: line) {
                return Int(line[valueRange]) ?? 0
            }
        }
        return 0
    }

    private static func parseLyricLines(
        _ rawLines: [String],
        offsetMs: Int
    ) -> [LyricLine] {
        var lines: [LyricLine] = []

        for rawLine in rawLines {
            let trimmed = rawLine.trimmingCharacters(in: .whitespaces)

            // Skip metadata-only lines
            if isMetadataLine(trimmed) { continue }

            // Extract timestamps
            let timestamps = extractTimestamps(trimmed)
            guard !timestamps.isEmpty else { continue }

            // Extract text after all timestamps
            let text = extractText(trimmed)
            guard !text.isEmpty else { continue }

            // Create a line for each timestamp
            for ts in timestamps {
                let adjustedTs = max(0.0, ts + Double(offsetMs) / 1000.0)
                lines.append(LyricLine(timestamp: adjustedTs, text: text))
            }

            if lines.count > 500 { break } // Safety bound
        }

        // Sort by timestamp and deduplicate
        lines.sort { $0.timestamp < $1.timestamp }
        return deduplicate(lines)
    }

    private static func isMetadataLine(_ line: String) -> Bool {
        line.hasPrefix("[ti:") ||
        line.hasPrefix("[ar:") ||
        line.hasPrefix("[al:") ||
        line.hasPrefix("[by:") ||
        line.hasPrefix("[length:") ||
        line.hasPrefix("[offset:")
    }

    private static func extractTimestamps(_ line: String) -> [TimeInterval] {
        var timestamps: [TimeInterval] = []
        let range = NSRange(line.startIndex..., in: line)

        let matches = timestampPattern.matches(in: line, range: range)
        for match in matches {
            guard match.numberOfRanges >= 4,
                  let minRange = Range(match.range(at: 1), in: line),
                  let secRange = Range(match.range(at: 2), in: line),
                  let subRange = Range(match.range(at: 3), in: line),
                  let minutes = Int(line[minRange]),
                  let seconds = Int(line[secRange]),
                  let subSeconds = Int(line[subRange]) else {
                continue
            }

            let ts = LRCUtils.parseTimestamp(
                minutes: minutes,
                seconds: seconds,
                subSeconds: subSeconds
            )
            timestamps.append(ts)
        }

        return timestamps
    }

    private static func extractText(_ line: String) -> String {
        let cleaned = timestampPattern.stringByReplacingMatches(
            in: line,
            range: NSRange(line.startIndex..., in: line),
            withTemplate: ""
        )
        return cleaned.trimmingCharacters(in: .whitespaces)
    }

    private static func deduplicate(_ lines: [LyricLine]) -> [LyricLine] {
        var seen = Set<TimeInterval>()
        return lines.filter { seen.insert($0.timestamp).inserted }
    }
}

// MARK: - Word Lyric Parser

public enum WordLyricParser {

    /// Converts NetEase word-by-word response to TimedLyricLine models.
    public static func parse(_ lines: [WordLyricLine]) -> [TimedLyricLine] {
        lines.map { line in
            TimedLyricLine(
                timestamp: Double(line.startTime) / 1000.0,
                text: line.content,
                translation: nil,
                words: line.words.map { word in
                    TimedWord(
                        startTime: Double(word.startTime) / 1000.0,
                        duration: Double(word.duration) / 1000.0,
                        text: word.text
                    )
                }
            )
        }
    }
}
