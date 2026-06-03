import Foundation

/// Fuzzy string matching for mapping Apple Music track names to NetEase search results.
public enum StringSimilarity {

    // MARK: - Dice Coefficient

    /// Computes the Dice coefficient between two strings [0, 1].
    /// Dice = 2 * |intersection| / (|a| + |b|)
    public static func diceCoefficient(_ a: String, _ b: String) -> Double {
        if a == b { return 1.0 }
        if a.count < 2 || b.count < 2 {
            return a == b ? 1.0 : 0.0
        }

        let bigramsA = bigrams(a)
        let bigramsB = bigrams(b)

        var intersection = 0
        for (bigram, count) in bigramsA {
            let countB = bigramsB[bigram] ?? 0
            intersection += min(count, countB)
        }

        return Double(2 * intersection) / Double(a.count - 1 + b.count - 1)
    }

    private static func bigrams(_ s: String) -> [String: Int] {
        var result: [String: Int] = [:]
        let chars = Array(s)
        for i in 0..<(chars.count - 1) {
            let bigram = String(chars[i...i+1])
            result[bigram, default: 0] += 1
        }
        return result
    }

    // MARK: - Normalization

    /// Normalizes a string for comparison: lowercase, remove parentheticals and punctuation.
    public static func normalize(_ str: String) -> String {
        var result = str.lowercased().trimmingCharacters(in: .whitespaces)

        // Remove parenthesized content like "(feat. Artist)" or "(Remastered 2021)"
        if let regex = try? NSRegularExpression(pattern: "\\([^)]*\\)", options: []) {
            result = regex.stringByReplacingMatches(
                in: result,
                range: NSRange(result.startIndex..., in: result),
                withTemplate: ""
            )
        }

        // Remove bracket content
        if let regex = try? NSRegularExpression(pattern: "\\[[^\\]]*\\]", options: []) {
            result = regex.stringByReplacingMatches(
                in: result,
                range: NSRange(result.startIndex..., in: result),
                withTemplate: ""
            )
        }

        // Remove featuring prefixes
        if let regex = try? NSRegularExpression(pattern: "\\b(feat\\.?|ft\\.?|featuring)\\s+", options: .caseInsensitive) {
            result = regex.stringByReplacingMatches(
                in: result,
                range: NSRange(result.startIndex..., in: result),
                withTemplate: ""
            )
        }

        // Remove special characters
        let allowed = CharacterSet.alphanumerics.union(.whitespaces)
        result = result.components(separatedBy: allowed.inverted).joined()

        // Collapse whitespace
        result = result.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        ).trimmingCharacters(in: .whitespaces)

        return result
    }

    // MARK: - Levenshtein

    /// Computes the Levenshtein (edit) distance between two strings.
    public static func levenshteinDistance(_ a: String, _ b: String) -> Int {
        let aChars = Array(a)
        let bChars = Array(b)
        let m = aChars.count
        let n = bChars.count

        if m == 0 { return n }
        if n == 0 { return m }

        var prev = Array(0...n)
        var curr = Array(repeating: 0, count: n + 1)

        for i in 1...m {
            curr[0] = i
            for j in 1...n {
                let cost = aChars[i - 1] == bChars[j - 1] ? 0 : 1
                curr[j] = min(
                    curr[j - 1] + 1,       // insertion
                    prev[j] + 1,            // deletion
                    prev[j - 1] + cost      // substitution
                )
            }
            swap(&prev, &curr)
        }

        return prev[n]
    }

    /// Normalized Levenshtein similarity [0, 1].
    public static func levenshteinSimilarity(_ a: String, _ b: String) -> Double {
        let maxLen = max(a.count, b.count)
        if maxLen == 0 { return 1.0 }
        return 1.0 - Double(levenshteinDistance(a, b)) / Double(maxLen)
    }

    // MARK: - Combined Scoring

    public struct MatchCandidate: Identifiable {
        public let id: String
        public let songName: String
        public let artistName: String

        public init(id: String, songName: String, artistName: String) {
            self.id = id
            self.songName = songName
            self.artistName = artistName
        }
    }

    public struct MatchScore {
        public let candidate: MatchCandidate
        public let score: Double
    }

    /// Scores and ranks match candidates against query.
    /// Weights: song name 70%, artist name 30%.
    public static func scoreMatches(
        querySong: String,
        queryArtist: String,
        candidates: [MatchCandidate]
    ) -> [MatchScore] {
        let normSong = normalize(querySong)
        let normArtist = normalize(queryArtist)

        return candidates.map { candidate in
            let normCandSong = normalize(candidate.songName)
            let normCandArtist = normalize(candidate.artistName)

            let songDice = diceCoefficient(normSong, normCandSong)
            let artistDice = diceCoefficient(normArtist, normCandArtist)
            let songLev = levenshteinSimilarity(normSong, normCandSong)
            let artistLev = levenshteinSimilarity(normArtist, normCandArtist)

            let songScore = songDice * 0.7 + songLev * 0.3
            let artistScore = artistDice * 0.7 + artistLev * 0.3
            let score = songScore * 0.7 + artistScore * 0.3

            return MatchScore(candidate: candidate, score: score)
        }.sorted { $0.score > $1.score }
    }
}
