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

                // Recently Played Albums
                if !libraryVM.recentlyPlayedAlbums.isEmpty {
                    sectionHeader("Recently Played Albums")
                    recentlyPlayedAlbumGrid
                }

                // Recently Played Playlists
                if !libraryVM.recentlyPlayedPlaylists.isEmpty {
                    sectionHeader("Recently Played Playlists")
                    recentlyPlayedPlaylistGrid
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
                if libraryVM.recentlyPlayedAlbums.isEmpty
                    && libraryVM.recentlyPlayedPlaylists.isEmpty
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

    // MARK: - Recently Played Albums

    private var recentlyPlayedAlbumGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(libraryVM.recentlyPlayedAlbums, id: \.id) { album in
                    recentlyPlayedAlbumCard(album)
                }
            }
            .padding(.horizontal)
        }
    }

    private func recentlyPlayedAlbumCard(_ album: Album) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let artwork = album.artwork {
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
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Text(album.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(width: 160, alignment: .leading)

            Text(album.artistName)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(width: 160, alignment: .leading)
        }
        .onTapGesture {
            Task { await playAlbum(album) }
        }
    }

    // MARK: - Recently Played Playlists

    private var recentlyPlayedPlaylistGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(libraryVM.recentlyPlayedPlaylists, id: \.id) { playlist in
                    recentlyPlayedPlaylistCard(playlist)
                }
            }
            .padding(.horizontal)
        }
    }

    private func recentlyPlayedPlaylistCard(_ playlist: Playlist) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let artwork = playlist.artwork {
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
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Text(playlist.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(width: 160, alignment: .leading)

            Text("Playlist")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 160, alignment: .leading)
        }
        .onTapGesture {
            Task { try? await libraryVM.playPlaylist(playlist) }
        }
    }

    // MARK: - Play Album

    private func playAlbum(_ album: Album) async {
        do {
            // Search for the album's tracks
            let songs = try await playerVM.search(query: "\(album.title) \(album.artistName)", limit: 1)
            if let song = songs.first {
                await playerVM.play(song: song)
            }
        } catch {
            // Silently fail
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
                .foregroundStyle(.secondary)
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

            if libraryVM.isDownloaded(song) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
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
