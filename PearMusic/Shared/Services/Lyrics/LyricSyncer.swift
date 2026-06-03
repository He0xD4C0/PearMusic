import Foundation

// MARK: - Lyric Syncer

/// High-performance lyric-to-playback synchronization.
/// Uses a high-frequency Timer (~60fps) with O(log n) binary search.
public final class LyricSyncer: @unchecked Sendable {

    private var timer: Timer?
    private var lines: [LyricLine] = []
    private var currentIndex: Int = -1
    private var getPlaybackTime: (() -> TimeInterval)?

    /// Called when the active lyric line changes.
    public var onLineChange: ((Int, LyricLine) -> Void)?

    /// Called every frame with the current playback time.
    public var onTick: ((TimeInterval) -> Void)?

    public init() {}

    deinit {
        stop()
    }

    // MARK: - Control

    /// Updates the lyric lines (e.g., after a song change or translation).
    public func setLines(_ lines: [LyricLine]) {
        self.lines = lines
        self.currentIndex = -1
    }

    /// Starts the sync loop at ~60fps.
    public func start(getPlaybackTime: @escaping () -> TimeInterval) {
        self.getPlaybackTime = getPlaybackTime
        self.currentIndex = -1

        stop()

        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0 / 60.0,
            repeats: true
        ) { [weak self] _ in
            self?.tick()
        }
    }

    /// Stops the sync loop.
    public func stop() {
        timer?.invalidate()
        timer = nil
    }

    /// Forces a re-sync (e.g., after seeking).
    public func seek() {
        currentIndex = -1
    }

    /// Returns whether the syncer is running.
    public var isRunning: Bool {
        timer?.isValid ?? false
    }

    // MARK: - Tick

    private func tick() {
        guard let getTime = getPlaybackTime else { return }
        guard !lines.isEmpty else { return }

        let currentTime = getTime()
        onTick?(currentTime)

        let newIndex = findLineIndex(for: currentTime)
        if newIndex != currentIndex {
            currentIndex = newIndex
            if newIndex >= 0, newIndex < lines.count {
                onLineChange?(newIndex, lines[newIndex])
            }
        }
    }

    // MARK: - Binary Search

    /// Binary search for the lyric line at the given playback time.
    /// Returns the index of the line that should be displayed as "active".
    private func findLineIndex(for time: TimeInterval) -> Int {
        if lines.isEmpty { return -1 }
        if time < lines[0].timestamp { return -1 }

        var low = 0
        var high = lines.count - 1

        while low <= high {
            let mid = (low + high) / 2
            let lineTime = lines[mid].timestamp

            if lineTime == time {
                return mid
            }
            if lineTime < time {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }

        return max(0, high)
    }
}
