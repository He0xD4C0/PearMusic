import SwiftUI

/// Small badge indicating the translation source.
struct TranslationBadge: View {
    enum Source {
        case native
        case ai
        case translating
        case none
    }

    let source: Source

    var body: some View {
        if source == .none { EmptyView() }

        HStack(spacing: 5) {
            if source == .translating {
                ProgressView()
                    .scaleEffect(0.5)
                    .frame(width: 12, height: 12)
            }
            Text(label)
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(background)
        .foregroundStyle(foreground)
        .clipShape(Capsule())
    }

    private var label: String {
        switch source {
        case .native: "Official Translation"
        case .ai: "AI Translation"
        case .translating: "Translating..."
        case .none: ""
        }
    }

    private var background: Color {
        switch source {
        case .native: Color.green.opacity(0.15)
        case .ai, .translating: Color.purple.opacity(0.15)
        case .none: Color.clear
        }
    }

    private var foreground: Color {
        switch source {
        case .native: Color.green
        case .ai, .translating: Color.purple
        case .none: Color.clear
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        TranslationBadge(source: .native)
        TranslationBadge(source: .ai)
        TranslationBadge(source: .translating)
    }
    .preferredColorScheme(.dark)
}
