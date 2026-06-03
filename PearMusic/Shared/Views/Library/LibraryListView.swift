import SwiftUI
import MusicKit

// MARK: - Library List View

/// Displays the user's playlists, library songs, and offline mode controls.
struct LibraryListView: View {
    @State private var libraryVM = LibraryViewModel.shared
    @State private var playerVM = PlayerViewModel.shared
    @State private var showNewPlaylistAlert = false
    @State private var newPlaylistName = ""

    var body: some View {
        List {
            // Offline Mode Toggle
            Section {
                HStack {
                    Label("Offline Mode", systemImage: "wifi.slash")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { libraryVM.offlineMode },
                        set: { _ in libraryVM.toggleOfflineMode() }
                    ))
                }
            }

            // Playlists
            Section("Playlists") {
                if libraryVM.playlists.isEmpty && !libraryVM.isLoading {
                    Text("No playlists yet")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ForEach(libraryVM.playlists, id: \.id) { playlist in
                    playlistRow(playlist)
                }

                Button {
                    showNewPlaylistAlert = true
                } label: {
                    Label("New Playlist", systemImage: "plus")
                }
            }

            // Library Songs
            Section("Songs") {
                if libraryVM.librarySongs.isEmpty && !libraryVM.isLoading {
                    Text("Add songs from Apple Music")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ForEach(libraryVM.librarySongs.prefix(50), id: \.id) { song in
                    librarySongRow(song)
                }

                if libraryVM.librarySongs.count > 50 {
                    Text("+ \(libraryVM.librarySongs.count - 50) more songs")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listStyle(.sidebar)
        .task {
            await libraryVM.refreshAll()
        }
        .refreshable {
            await libraryVM.refreshAll()
        }
        .alert("New Playlist", isPresented: $showNewPlaylistAlert) {
            TextField("Playlist Name", text: $newPlaylistName)
            Button("Cancel", role: .cancel) {}
            Button("Create") {
                Task {
                    _ = try? await libraryVM.createPlaylist(name: newPlaylistName)
                    newPlaylistName = ""
                }
            }
        }
    }

    // MARK: - Playlist Row

    private func playlistRow(_ playlist: Playlist) -> some View {
        HStack(spacing: 12) {
            // Artwork
            if let artwork = playlist.artwork {
                AsyncImage(url: artwork.url(width: 44, height: 44)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        playlistPlaceholder
                    }
                }
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                playlistPlaceholder
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(playlist.name)
                    .font(.body)
                    .lineLimit(1)
                Text("Playlist")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Task { try? await libraryVM.playPlaylist(playlist) }
        }
        .contextMenu {
            Button {
                Task { try? await libraryVM.playPlaylist(playlist) }
            } label: {
                Label("Play", systemImage: "play.fill")
            }

            Button(role: .destructive) {
                Task { try? await libraryVM.deletePlaylist(playlist) }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private var playlistPlaceholder: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.secondary.opacity(0.15))
            .frame(width: 44, height: 44)
            .overlay {
                Image(systemName: "music.note.list")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
    }

    // MARK: - Library Song Row

    private func librarySongRow(_ song: Song) -> some View {
        HStack(spacing: 12) {
            if let artwork = song.artwork {
                AsyncImage(url: artwork.url(width: 36, height: 36)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Rectangle().fill(Color.secondary.opacity(0.15))
                    }
                }
                .frame(width: 36, height: 36)
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

            // Download status
            if libraryVM.isDownloaded(song) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Task { await playerVM.play(song: song) }
        }
        .contextMenu {
            Button {
                Task { await playerVM.play(song: song) }
            } label: {
                Label("Play", systemImage: "play.fill")
            }

            Button {
                playerVM.addToQueue(song)
            } label: {
                Label("Add to Queue", systemImage: "text.badge.plus")
            }

            Button {
                Task { try? await libraryVM.downloadSong(song) }
            } label: {
                Label("Download", systemImage: "arrow.down")
            }
            .disabled(libraryVM.isDownloaded(song))

            Divider()

            Button(role: .destructive) {
                Task { try? await libraryVM.removeSongFromLibrary(song) }
            } label: {
                Label("Remove from Library", systemImage: "trash")
            }
        }
    }
}

#Preview {
    LibraryListView()
        .preferredColorScheme(.dark)
}
