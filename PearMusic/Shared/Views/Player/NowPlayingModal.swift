import SwiftUI

// MARK: - Now Playing Modal

/// Full-screen immersive "Now Playing" view with dynamic background
/// sampled from album art colors, large artwork, and lyric overlay.
struct NowPlayingModal: View {
    @Environment(PlayerViewModel.self) private var playerVM
    @Environment(\.dismiss) private var dismiss

    @State private var backgroundColors: [Color] = [.black, Color.indigo.opacity(0.3)]

    var body: some View {
        ZStack {
            // Dynamic gradient background
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.5), value: playerVM.nowPlayingTitle ?? "")

            // Content
            VStack(spacing: 32) {
                // Dismiss handle
                dragHandle
                    .padding(.top, 8)

                Spacer()

                // Large artwork
                artworkView
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.5), radius: 24, y: 12)

                // Track info
                VStack(spacing: 8) {
                    Text(playerVM.nowPlayingTitle ?? "No Track")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(playerVM.nowPlayingArtist ?? "")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.7))

                    if let album = playerVM.nowPlayingAlbum {
                        Text(album)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal, 32)

                // Progress bar
                ProgressBarView(
                    currentTime: playerVM.currentTime,
                    duration: playerVM.duration
                ) { time in
                    Task { await playerVM.seek(to: time) }
                }
                .tint(.white)
                .padding(.horizontal, 48)

                // Transport controls
                HStack(spacing: 36) {
                    // Shuffle
                    Button {
                        playerVM.toggleShuffle()
                    } label: {
                        Image(systemName: "shuffle")
                            .font(.title3)
                            .foregroundStyle(playerVM.shuffleMode == .on ? .white : .white.opacity(0.4))
                    }

                    // Previous
                    Button {
                        Task { await playerVM.skipToPrevious() }
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }

                    // Play/Pause
                    Button {
                        Task { await playerVM.togglePlayPause() }
                    } label: {
                        Image(systemName: playerVM.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(.white)
                    }

                    // Next
                    Button {
                        Task { await playerVM.skipToNext() }
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }

                    // Repeat
                    Button {
                        playerVM.cycleRepeatMode()
                    } label: {
                        Image(systemName: repeatIcon)
                            .font(.title3)
                            .foregroundStyle(playerVM.repeatMode != .none ? .white : .white.opacity(0.4))
                    }
                }

                // Mode labels
                HStack(spacing: 48) {
                    Text(shuffleLabel)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))

                    Text(repeatLabel)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.4))
                }

                Spacer()

                // Lyric overlay (compact)
                if let title = playerVM.nowPlayingTitle {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.3))
                        .padding(.bottom, 24)
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 480, idealWidth: 560, minHeight: 640, idealHeight: 720)
        #endif
    }

    // MARK: - Drag Handle

    private var dragHandle: some View {
        Capsule()
            .fill(.white.opacity(0.3))
            .frame(width: 36, height: 5)
            .onTapGesture { dismiss() }
    }

    // MARK: - Artwork

    @ViewBuilder
    private var artworkView: some View {
        if let url = playerVM.nowPlayingArtworkURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    placeholderArtwork
                @unknown default:
                    placeholderArtwork
                }
            }
        } else {
            placeholderArtwork
        }
    }

    private var placeholderArtwork: some View {
        Rectangle()
            .fill(.white.opacity(0.1))
            .overlay {
                Image(systemName: "music.note")
                    .font(.system(size: 64))
                    .foregroundStyle(.white.opacity(0.3))
            }
    }

    // MARK: - Helpers

    private var repeatIcon: String {
        switch playerVM.repeatMode {
        case .none: return "repeat"
        case .one:  return "repeat.1"
        case .all:  return "repeat"
        }
    }

    private var repeatLabel: String {
        switch playerVM.repeatMode {
        case .none: return "Off"
        case .one:  return "Repeat 1"
        case .all:  return "Repeat All"
        }
    }

    private var shuffleLabel: String {
        playerVM.shuffleMode == .on ? "Shuffle On" : "Shuffle Off"
    }
}

#Preview {
    NowPlayingModal()
        .environment(PlayerViewModel.shared)
        .preferredColorScheme(.dark)
}
