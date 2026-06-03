import SwiftUI
import MusicKit

/// Root view — adapts layout for macOS and iOS.
///
/// Auth flow: notDetermined → sign-in → denied? → system settings → authorized → player
///
/// - **macOS**: `NavigationSplitView` with sidebar (Browse, Library, Search, Lyrics)
/// - **iOS**: `TabView` with 4 tabs
struct ContentView: View {
    @State private var playerVM = PlayerViewModel.shared
    @State private var lyricVM = LyricViewModel()
    @State private var setupVM = SetupViewModel()

    @State private var showSettings = false
    @State private var showNowPlaying = false

    #if os(macOS)
    @State private var selectedTab: SidebarTab = .browse
    #else
    @State private var selectedTab: AppTab = .browse
    #endif

    var body: some View {
        Group {
            if playerVM.isAuthorized {
                mainView
            } else {
                authorizeView
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: setupVM)
        }
        .sheet(isPresented: $showNowPlaying) {
            NowPlayingModal()
                .environment(playerVM)
        }
        .task {
            playerVM.checkAuthorization()
        }
        .onChange(of: playerVM.nowPlayingTitle) { _, newValue in
            guard let title = newValue,
                  let artist = playerVM.nowPlayingArtist else {
                lyricVM.reset()
                return
            }
            Task {
                configureServicesIfNeeded()
                await lyricVM.fetchLyrics(artist: artist, title: title)
            }
        }
    }

    // MARK: - Authorization

    private var authorizeView: some View {
        VStack(spacing: 24) {
            Image(systemName: playerVM.authStatusSymbol)
                .font(.system(size: 48))
                .foregroundStyle(.tint)

            Text("PearMusic")
                .font(.largeTitle.bold())

            Text(playerVM.authStatusMessage)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            switch playerVM.authorizationStatus {
            case .notDetermined:
                Button {
                    Task { await playerVM.authorize() }
                } label: {
                    Text("Sign In with Apple Music")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

            case .denied:
                VStack(spacing: 12) {
                    Button {
                        playerVM.openSystemSettings()
                    } label: {
                        Label("Open System Settings", systemImage: "gearshape")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button {
                        Task { await playerVM.authorize() }
                    } label: {
                        Text("Try Again")
                    }
                    .buttonStyle(.borderless)
                }

            case .restricted:
                EmptyView()

            default:
                Button {
                    Task { await playerVM.authorize() }
                } label: {
                    Text("Sign In with Apple Music")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }

            if let error = playerVM.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
    }

    // MARK: - Main View (Adaptive)

    @ViewBuilder
    private var mainView: some View {
        #if os(macOS)
        macOSLayout
        #else
        iOSLayout
        #endif
    }

    // MARK: - macOS Layout

    #if os(macOS)
    private var macOSLayout: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selectedTab) {
                Label("Browse", systemImage: "square.grid.2x2")
                    .tag(SidebarTab.browse)
                Label("Library", systemImage: "music.note.list")
                    .tag(SidebarTab.library)
                Label("Search", systemImage: "magnifyingglass")
                    .tag(SidebarTab.search)
                Label("Lyrics", systemImage: "text.bubble")
                    .tag(SidebarTab.lyrics)
            }
            .listStyle(.sidebar)
            .navigationTitle("PearMusic")
        } detail: {
            VStack(spacing: 0) {
                // Content area
                Group {
                    switch selectedTab {
                    case .browse:
                        BrowseView()
                    case .library:
                        LibraryListView()
                    case .search:
                        SearchView()
                    case .lyrics:
                        LyricScrollView()
                            .environment(lyricVM)
                            .environment(playerVM)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()

                // Mini player bar at bottom
                miniPlayerBar
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }

            if lyricVM.canTranslate {
                ToolbarItem(placement: .automatic) {
                    Button {
                        Task { await lyricVM.triggerTranslation() }
                    } label: {
                        Label("AI Translate", systemImage: "translate")
                    }
                    .disabled(lyricVM.isTranslating)
                }
            }

            ToolbarItem(placement: .automatic) {
                Button {
                    showNowPlaying = true
                } label: {
                    Label("Now Playing", systemImage: "music.note")
                }
            }
        }
    }

    private var miniPlayerBar: some View {
        HStack(spacing: 12) {
            // Artwork thumbnail
            if let url = playerVM.nowPlayingArtworkURL {
                AsyncImage(url: url) { phase in
                    if case .success(let image) = phase {
                        image.resizable().aspectRatio(contentMode: .fill)
                    }
                }
                .frame(width: 32, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(playerVM.nowPlayingTitle ?? "No Track")
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(playerVM.nowPlayingArtist ?? "")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Controls
            HStack(spacing: 16) {
                Button {
                    Task { await playerVM.skipToPrevious() }
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.caption)
                }
                .buttonStyle(.plain)

                Button {
                    Task { await playerVM.togglePlayPause() }
                } label: {
                    Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
                        .font(.body)
                }
                .buttonStyle(.plain)

                Button {
                    Task { await playerVM.skipToNext() }
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }

            // Expand to full player
            Button {
                showNowPlaying = true
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.regularMaterial)
    }

    enum SidebarTab: String, Hashable {
        case browse, library, search, lyrics
    }
    #endif

    // MARK: - iOS Layout

    #if os(iOS)
    private var iOSLayout: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                BrowseView()
            }
            .tabItem {
                Label("Browse", systemImage: "square.grid.2x2")
            }
            .tag(AppTab.browse)

            NavigationStack {
                LibraryListView()
            }
            .tabItem {
                Label("Library", systemImage: "music.note.list")
            }
            .tag(AppTab.library)

            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(AppTab.search)

            NavigationStack {
                LyricScrollView()
                    .environment(lyricVM)
                    .environment(playerVM)
            }
            .tabItem {
                Label("Lyrics", systemImage: "text.bubble")
            }
            .tag(AppTab.lyrics)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .overlay(alignment: .bottom) {
            // Mini player strip
            miniPlayerStrip
        }
    }

    private var miniPlayerStrip: some View {
        HStack {
            if let url = playerVM.nowPlayingArtworkURL {
                AsyncImage(url: url) { phase in
                    if case .success(let image) = phase {
                        image.resizable().aspectRatio(contentMode: .fill)
                    }
                }
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(playerVM.nowPlayingTitle ?? "No Track")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(playerVM.nowPlayingArtist ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                Task { await playerVM.togglePlayPause() }
            } label: {
                Image(systemName: playerVM.isPlaying ? "pause.fill" : "play.fill")
                    .font(.title3)
            }
            .buttonStyle(.plain)

            Button {
                Task { await playerVM.skipToNext() }
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .onTapGesture {
            showNowPlaying = true
        }
    }

    enum AppTab: String, Hashable {
        case browse, library, search, lyrics
    }
    #endif

    // MARK: - Service Configuration

    private func configureServicesIfNeeded() {
        guard lyricVM.neteaseSearchService == nil,
              setupVM.isNeteaseConfigured else { return }

        let httpClient = NeteaseHTTPClient(
            appId: setupVM.neteaseAppId,
            privateKeyBase64: setupVM.neteasePrivateKey,
            deviceId: setupVM.deviceId
        )

        lyricVM.neteaseSearchService = NeteaseSearchService(httpClient: httpClient)
        lyricVM.neteaseLyricService = NeteaseLyricService(httpClient: httpClient)

        if setupVM.isAIConfigured {
            let llmConfig = LLMConfig(
                apiKey: setupVM.aiApiKey,
                model: setupVM.aiModel,
                baseURL: setupVM.aiBaseURL
            )
            lyricVM.translationPipeline = TranslationPipeline(
                llmClient: LLMClient(config: llmConfig)
            )
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
