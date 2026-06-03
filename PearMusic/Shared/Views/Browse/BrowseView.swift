import SwiftUI
import MusicKit

// MARK: - Browse View

/// Home/Browse tab showing recently played, recommendations, and
/// quick-access sections.
struct BrowseView: View {
    @State private var libraryVM = LibraryViewModel.shared
    @State private var playerVM = PlayerViewModel.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                Text("Browse")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)

                // Recently Played
                if !libraryVM.recentlyPlayed.isEmpty {
                    sectionHeader("Recently Played")
                    recentlyPlayedGrid
                }

                // Recommendations
                if !libraryVM.recommendations.isEmpty {
                    sectionHeader("Made for You")
                    recommendationsList
                }

                // Library Songs
                if !libraryVM.librarySongs.isEmpty {
                    sectionHeader("Your Library")
                    librarySongsList
                }

                // Loading
                if libraryVM.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .padding()
                }

                // Empty state
                if libraryVM.recentlyPlayed.isEmpty
                    && libraryVM.recommendations.isEmpty
                    && libraryVM.librarySongs.isEmpty
                    && !libraryVM.isLoading {
                    emptyState
                }
            }
            .padding(.vertical)
        }
        .task {
            await libraryVM.refreshAll()
        }
        .refreshable {
            await libraryVM.refreshAll()
        }
    }

    // MARK: - Sections

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3.bold())
            .padding(.horizontal)
    }

    // MARK: - Recently Played

    private var recentlyPlayedGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(libraryVM.recentlyPlayed, id: \.id) { item in
                    recentlyPlayedCard(item)
                }
            }
            .padding(.horizontal)
        }
    }

    private func recentlyPlayedCard(_ item: RecentlyPlayedItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Artwork
            if let artwork = item.artwork {
                AsyncImage(url: artwork.url(width: 160, height: 160)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Rectangle().fill(Color.secondary.opacity(0.15))
                    }
                }
                .frame(width: 160, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Text(item.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(width: 160, alignment: .leading)

            Text(item.subtitle ?? "")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(width: 160, alignment: .leading)
        }
        .onTapGesture {
            Task {
                // Play the item if it's a playlist
                await playRecentlyPlayedItem(item)
            }
        }
    }

    private func playRecentlyPlayedItem(_ item: RecentlyPlayedItem) async {
        // RecentlyPlayedItem can be albums, playlists, stations, etc.
        // For now, try to play it. If it's a playlist container, fetch tracks.
        do {
            // Try searching for the title as a fallback
            let songs = try await playerVM.search(query: item.title, limit: 1)
            if let song = songs.first {
                await playerVM.play(song: song)
            }
        } catch {
            // Silently fail — browse items may not always be playable
        }
    }

    // MARK: - Recommendations

    private var recommendationsList: some View {
        VStack(spacing: 12) {
            ForEach(libraryVM.recommendations, id: \.id) { recommendation in
                recommendationRow(recommendation)
            }
        }
        .padding(.horizontal)
    }

    private func recommendationRow(_ recommendation: MusicPersonalRecommendation) -> some View {
        HStack(spacing: 12) {
            if let artwork = recommendation.artwork {
                AsyncImage(url: artwork.url(width: 64, height: 64)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Rectangle().fill(Color.secondary.opacity(0.15))
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.title)
                    .font(.headline)
                    .lineLimit(1)
                if let subtitle = recommendation.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color.secondary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Library Songs

    private var librarySongsList: some View {
        VStack(spacing: 2) {
            ForEach(libraryVM.librarySongs.prefix(20), id: \.id) { song in
                songRow(song)
            }
        }
    }

    private func songRow(_ song: Song) -> some View {
        HStack(spacing: 12) {
            if let artwork = song.artwork {
                AsyncImage(url: artwork.url(width: 44, height: 44)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Rectangle().fill(Color.secondary.opacity(0.15))
                    }
                }
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(song.title)
                    .font(.body)
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "ellipsis")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .opacity(0)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            Task { await playerVM.play(song: song) }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.house")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("Your Library is Empty")
                .font(.headline)

            Text("Add songs from Apple Music to start building your library.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 64)
    }
}

#Preview {
    BrowseView()
        .preferredColorScheme(.dark)
}
