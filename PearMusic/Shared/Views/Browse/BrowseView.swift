import SwiftUI
import MusicKit

// MARK: - Browse View

/// Home/Browse tab showing library songs and quick-access sections.
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

                // Library Playlists
                if !libraryVM.playlists.isEmpty {
                    sectionHeader("Your Playlists")
                    playlistsGrid
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
                if libraryVM.playlists.isEmpty
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

    // MARK: - Playlists

    private var playlistsGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(libraryVM.playlists, id: \.id) { playlist in
                    playlistCard(playlist)
                }
            }
            .padding(.horizontal)
        }
    }

    private func playlistCard(_ playlist: Playlist) -> some View {
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
                    .overlay {
                        Image(systemName: "music.note.list")
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
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
