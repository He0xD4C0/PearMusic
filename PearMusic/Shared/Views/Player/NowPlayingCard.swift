import SwiftUI

/// Displays album artwork + track info for the currently playing song.
struct NowPlayingCard: View {
    let title: String?
    let artist: String?
    let album: String?
    let artworkURL: URL?
    let isPlaying: Bool

    var body: some View {
        HStack(spacing: 14) {
            // Artwork
            artworkView
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Info
            VStack(alignment: .leading, spacing: 2) {
                Text(title ?? "No Track Playing")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(artist ?? "Select a song to begin")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if let album {
                    Text(album)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var artworkView: some View {
        if let url = artworkURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    placeholderArtwork
                case .empty:
                    ProgressView().tint(.secondary)
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
            .fill(Color.secondary.opacity(0.15))
            .overlay {
                Image(systemName: "music.note")
                    .font(.title2)
                    .foregroundStyle(.tertiary)
            }
    }
}

#Preview {
    NowPlayingCard(
        title: "Bohemian Rhapsody",
        artist: "Queen",
        album: "A Night at the Opera",
        artworkURL: nil,
        isPlaying: true
    )
    .preferredColorScheme(.dark)
}
