import Foundation

/// LRC timestamp formatting helpers.
public enum LRCUtils {

    // MARK: - Timestamp Formatting

    /// Formats a TimeInterval to LRC timestamp [mm:ss.xx].
    public static func formatTimestamp(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let centiseconds = Int((time - Double(totalSeconds)) * 100)

        return String(
            format: "[%02d:%02d.%02d]",
            minutes, seconds, centiseconds
        )
    }

    /// Parses an LRC timestamp to TimeInterval.
    public static func parseTimestamp(
        minutes: Int,
        seconds: Int,
        subSeconds: Int
    ) -> TimeInterval {
        let ms = subSeconds >= 100
            ? Double(subSeconds) / 1000.0
            : Double(subSeconds) / 100.0
        return Double(minutes * 60) + Double(seconds) + ms
    }

    // MARK: - Duration Formatting

    /// Formats a duration to human-readable "m:ss".
    public static func formatDuration(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
}
