import SwiftUI
import MusicKit

// MARK: - Search View

/// Apple Music catalog search with results, queue actions, and recent searches.
struct SearchView: View {
    @State private var searchVM = SearchViewModel()
    @State private var playerVM = PlayerViewModel.shared

    var body: some View {
        VStack(spacing: 0) {
            // Search field
            searchField
                .padding(.horizontal)
                .padding(.vertical, 8)

            Divider()

            // Results or recents
            if searchVM.hasSearched {
                if searchVM.isSearching {
                    Spacer()
                    ProgressView("Searching...")
                    Spacer()
                } else if searchVM.results.isEmpty {
                    emptyResults
                } else {
                    resultsList
                }
            } else if !searchVM.recentSearches.isEmpty {
                recentSearchesList
            } else {
                searchPrompt
            }
        }
    }

    // MARK: - Search Field

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search Apple Music...", text: $searchVM.query)
                .textFieldStyle(.plain)
                .onSubmit {
                    Task { await searchVM.search() }
                }

            if !searchVM.query.isEmpty {
                Button {
                    searchVM.clear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Results

    private var resultsList: some View {
        List {
            // Play All button
            if !searchVM.results.isEmpty {
                Section {
                    Button {
                        Task { try? await searchVM.playAllResults() }
                    } label: {
                        Label("Play All", systemImage: "play.fill")
                    }

                    Button {
                        // Add all to queue
                        for song in searchVM.results {
                            playerVM.addToQueue(song)
                        }
                    } label: {
                        Label("Add All to Queue", systemImage: "text.badge.plus")
                    }
                }
            }

            // Songs
            Section("Songs") {
                ForEach(searchVM.results, id: \.id) { song in
                    resultRow(song)
                }
            }
        }
        .listStyle(.inset)
    }

    private func resultRow(_ song: Song) -> some View {
        HStack(spacing: 12) {
            // Artwork
            if let artwork = song.artwork {
                AsyncImage(url: artwork.url(width: 48, height: 48)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Rectangle().fill(Color.secondary.opacity(0.15))
                    }
                }
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(song.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                if let album = song.albumTitle {
                    Text(album)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Quick actions
            Menu {
                Button {
                    Task { try? await searchVM.playSong(song) }
                } label: {
                    Label("Play", systemImage: "play.fill")
                }

                Button {
                    searchVM.playNext(song)
                } label: {
                    Label("Play Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                }

                Button {
                    searchVM.addToQueue(song)
                } label: {
                    Label("Add to Queue", systemImage: "text.badge.plus")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Task { try? await searchVM.playSong(song) }
        }
    }

    // MARK: - Empty Results

    private var emptyResults: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No Results")
                .font(.headline)

            Text("No songs found for \"\(searchVM.query)\".\nTry a different search term.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Recent Searches

    private var recentSearchesList: some View {
        List {
            Section("Recent Searches") {
                ForEach(searchVM.recentSearches, id: \.self) { term in
                    Button {
                        searchVM.query = term
                        Task { await searchVM.search() }
                    } label: {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundStyle(.secondary)
                            Text(term)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
    }

    // MARK: - Prompt

    private var searchPrompt: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("Search Apple Music")
                .font(.headline)

            Text("Find songs, albums, and artists in the\nApple Music catalog.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
