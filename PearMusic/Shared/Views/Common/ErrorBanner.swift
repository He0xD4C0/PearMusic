import SwiftUI

/// Error banner with dismiss and retry actions.
struct ErrorBanner: View {
    let message: String
    let onDismiss: () -> Void
    let onRetry: (() -> Void)?

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)

            Text(message)
                .font(.caption)
                .lineLimit(3)

            Spacer()

            if let retry = onRetry {
                Button("Retry", action: retry)
                    .buttonStyle(.borderless)
                    .font(.caption.weight(.medium))
            }

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    ErrorBanner(
        message: "Failed to load lyrics. Check your network connection.",
        onDismiss: {},
        onRetry: {}
    )
    .preferredColorScheme(.dark)
}
