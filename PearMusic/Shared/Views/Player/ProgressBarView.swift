import SwiftUI

/// Playback progress bar with time labels.
struct ProgressBarView: View {
    let currentTime: TimeInterval
    let duration: TimeInterval
    let onSeek: (TimeInterval) -> Void

    var body: some View {
        VStack(spacing: 4) {
            // Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 4)

                    Capsule()
                        .fill(.tint)
                        .frame(width: progressWidth(in: geo), height: 4)
                }
            }
            .frame(height: 4)
            .contentShape(Rectangle())

            // Time labels
            HStack {
                Text(formatTime(currentTime))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .monospacedDigit()

                Spacer()

                Text(formatTime(duration))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal)
    }

    private func progressWidth(in geo: GeometryProxy) -> CGFloat {
        guard duration > 0 else { return 0 }
        return geo.size.width * CGFloat(currentTime / duration)
    }

    private func formatTime(_ time: TimeInterval) -> String {
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
