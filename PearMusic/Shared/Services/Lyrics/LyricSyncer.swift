import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Lyric Syncer

/// High-performance lyric-to-playback synchronization using CADisplayLink.
/// Fires at display refresh rate (60fps on most Macs) with O(log n) binary search.
public final class LyricSyncer: @unchecked Sendable {

    private var displayLink: CADisplayLink?
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

    /// Starts the CADisplayLink sync loop.
    public func start(getPlaybackTime: @escaping () -> TimeInterval) {
        self.getPlaybackTime = getPlaybackTime
        self.currentIndex = -1

        stop()

        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .main, forMode: .common)
    }

    /// Stops the sync loop.
    public func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    /// Forces a re-sync (e.g., after seeking).
    public func seek() {
        currentIndex = -1
    }

    /// Returns whether the syncer is running.
    public var isRunning: Bool {
        displayLink != nil && !(displayLink?.isPaused ?? true)
    }

    // MARK: - Tick

    @objc private func tick() {
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
