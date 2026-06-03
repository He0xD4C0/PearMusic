import SwiftUI

/// Animated shimmer placeholder for loading states.
struct ShimmerView: View {
    @State private var phase: CGFloat = -1

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.secondary.opacity(0.15),
                        Color.secondary.opacity(0.3),
                        Color.secondary.opacity(0.15),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .mask(
                GeometryReader { geo in
                    Rectangle()
                        .offset(x: phase * geo.size.width)
                }
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

#Preview {
    VStack(spacing: 8) {
        ShimmerView().frame(width: 200, height: 16)
        ShimmerView().frame(width: 280, height: 16)
        ShimmerView().frame(width: 160, height: 16)
    }
    .preferredColorScheme(.dark)
    .padding()
}
