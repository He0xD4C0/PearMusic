import SwiftUI

/// Playback progress bar with time labels and drag-to-seek support.
struct ProgressBarView: View {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let onSeek: (TimeInterval) -> Void

    @State private var isDragging = false
    @State private var dragValue: CGFloat = 0

    var body: some View {
        VStack(spacing: 4) {
            // Bar
            GeometryReader { geo in
                let barWidth = geo.size.width
                let progress = duration > 0 ? CGFloat(currentTime / duration) : 0
                let displayProgress = isDragging ? dragValue : progress

                ZStack(alignment: .leading) {
                    // Track
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: isDragging ? 6 : 4)

                    // Progress
                    Capsule()
                        .fill(.tint)
                        .frame(
                            width: min(displayProgress * barWidth, barWidth),
                            height: isDragging ? 6 : 4
                        )

                    // Thumb (visible when dragging)
                    if isDragging {
                        Circle()
                            .fill(.tint)
                            .frame(width: 14, height: 14)
                            .offset(x: min(displayProgress * barWidth - 7, barWidth - 7))
                    }
                }
                .animation(.easeOut(duration: 0.1), value: isDragging)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            let clamped = min(max(value.location.x / barWidth, 0), 1)
                            dragValue = clamped
                        }
                        .onEnded { _ in
                            isDragging = false
                            let seekTime = dragValue * duration
                            onSeek(seekTime)
                        }
                )
            }
            .frame(height: 14)  // Hit target height for drag

            // Time labels
            HStack {
                Text(formatTime(isDragging ? dragValue * duration : currentTime))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()

                Spacer()

                Text(formatTime(duration))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        guard time.isFinite else { return "0:00" }
        let total = Int(time)
        let min = total / 60
        let sec = total % 60
        return "\(min):\(String(format: "%02d", sec))"
    }
}

#Preview {
    ProgressBarView(currentTime: 95, duration: 210) { _ in }
        .preferredColorScheme(.dark)
}
