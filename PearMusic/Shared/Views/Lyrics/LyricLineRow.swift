import SwiftUI

/// A single lyric line with active/past/future states.
struct LyricLineRow: View {
    let text: String
    let translation: String?
    let isActive: Bool
    let isPast: Bool
    let onTap: () -> Void

    @State private var isHovering = false

    var body: some View {
        VStack(spacing: 2) {
            Text(text)
                .font(isActive ? .title3.weight(.semibold) : .body)
                .foregroundStyle(textColor)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            if let translation {
                Text(translation)
                    .font(isActive ? .subheadline : .caption)
                    .foregroundStyle(translationColor)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(minHeight: 48)
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovering ? Color.secondary.opacity(0.15) : Color.clear)
        )
        .animation(.spring(response: 0.3), value: isActive)
    }

    private var textColor: Color {
        if isActive { return .primary }
        if isPast { return .secondary.opacity(0.5) }
        return .secondary.opacity(0.35)
    }

    private var translationColor: Color {
        if isActive { return .secondary }
        if isPast { return .secondary.opacity(0.35) }
        return .secondary.opacity(0.2)
    }
}

#Preview {
    VStack {
        LyricLineRow(text: "Is this the real life?",
                     translation: "这是真实的人生吗？",
                     isActive: false, isPast: true) {}
        LyricLineRow(text: "Is this just fantasy?",
                     translation: "还是梦幻一场？",
                     isActive: true, isPast: false) {}
        LyricLineRow(text: "Caught in a landslide",
                     translation: nil,
                     isActive: false, isPast: false) {}
    }
    .preferredColorScheme(.dark)
}
