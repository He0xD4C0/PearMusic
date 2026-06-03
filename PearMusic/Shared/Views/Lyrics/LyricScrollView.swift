import SwiftUI

/// Main lyric display with auto-scrolling to active line.
struct LyricScrollView: View {
    @Environment(LyricViewModel.self) private var lyricVM
    @Environment(PlayerViewModel.self) private var playerVM

    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Badge
            TranslationBadge(source: badgeSource)
                .padding(12)

            // Content
            switch lyricVM.lyricState {
            case .idle:
                emptyState(
                    icon: "music.note",
                    title: "Play a Song",
                    subtitle: "Lyrics will appear here"
                )

            case .loading:
                loadingState

            case .noLyric:
                emptyState(
                    icon: "music.quarternote.3",
                    title: "Instrumental / Pure Music",
                    subtitle: "This track has no lyrics"
                )

            case .unavailable:
                emptyState(
                    icon: "text.badge.xmark",
                    title: "Lyrics Unavailable",
                    subtitle: "We couldn't find lyrics for this track"
                )

            case .native, .nativeOriginal, .aiTranslated, .wordTimed:
                lyricLinesList

            case .aiTranslating:
                ZStack {
                    lyricLinesList
                    translatingOverlay
                }

            case .error(let message):
                errorState(message: message)
            }
        }
    }

    // MARK: - Views

    private var lyricLinesList: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    // Top spacer to center first lines
                    Color.clear.frame(height: 200)

                    if let lines = lyricVM.lines {
                        ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                            LyricLineRow(
                                text: line.text,
                                translation: line.translation,
                                isActive: index == lyricVM.activeLineIndex,
                                isPast: index < lyricVM.activeLineIndex,
                                onTap: {
                                    Task { await playerVM.seek(to: line.timestamp) }
                                }
                            )
                            .id(index)
                        }
                    }

                    // Bottom spacer
                    Color.clear.frame(height: 300)
                }
            }
            .onAppear { scrollProxy = proxy }
            .onChange(of: lyricVM.activeLineIndex) { _, newIndex in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newIndex, anchor: .center)
                }
            }
        }
    }

    private var translatingOverlay: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("AI is translating lyrics...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Searching for lyrics...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func emptyState(
        icon: String,
        title: String,
        subtitle: String
    ) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(.tertiary)
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorState(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 36))
                .foregroundStyle(.orange)
            Text("Error")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private var badgeSource: TranslationBadge.Source {
        switch lyricVM.lyricState {
        case .native: .native
        case .aiTranslated: .ai
        case .aiTranslating: .translating
        default: .none
        }
    }
}

#Preview {
    LyricScrollView()
        .environment(LyricViewModel())
        .environment(PlayerViewModel.shared)
        .preferredColorScheme(.dark)
}
