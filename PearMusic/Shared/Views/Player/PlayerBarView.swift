import SwiftUI

/// Top bar combining artwork, controls, and progress bar.
struct PlayerBarView: View {
    @Environment(PlayerViewModel.self) private var playerVM

    var body: some View {
        VStack(spacing: 12) {
            NowPlayingCard(
                title: playerVM.nowPlayingTitle,
                artist: playerVM.nowPlayingArtist,
                album: playerVM.nowPlayingAlbum,
                artworkURL: playerVM.nowPlayingArtworkURL,
                isPlaying: playerVM.isPlaying
            )

            HStack(spacing: 24) {
                // Previous
                Button {
                    Task { await playerVM.skipToPrevious() }
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.leftArrow, modifiers: [.command])

                // Play/Pause
                Button {
                    Task {
                        if playerVM.isPlaying {
                            playerVM.pause()
                        } else {
                            await playerVM.play()
                        }
                    }
                } label: {
                    Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.space, modifiers: [])

                // Next
                Button {
                    Task { await playerVM.skipToNext() }
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .keyboardShortcut(.rightArrow, modifiers: [.command])
            }

            if playerVM.nowPlayingTitle != nil {
                ProgressBarView(
                    currentTime: playerVM.currentTime,
                    duration: playerVM.duration
                ) { time in
                    Task { await playerVM.seek(to: time) }
                }
            }
        }
        .padding(.vertical, 12)
        .background(.regularMaterial)
    }
}

#Preview {
    PlayerBarView()
        .environment(PlayerViewModel.shared)
        .preferredColorScheme(.dark)
}
