import SwiftUI
import MusicKit

/// Root view — adapts layout for macOS and iOS.
struct ContentView: View {
    @State private var playerVM = PlayerViewModel.shared
    @State private var lyricVM = LyricViewModel()
    @State private var setupVM = SetupViewModel()

    @State private var showSettings = false

    var body: some View {
        Group {
            if !playerVM.isAuthorized {
                // ── Authorization View ──
                authorizeView
            } else {
                // ── Main Player View ──
                mainView
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: setupVM)
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
            Image(systemName: "music.note.house.fill")
                .font(.system(size: 48))
                .foregroundStyle(.tint)

            Text("PearMusic")
                .font(.largeTitle.bold())

            Text("Apple Music streaming with AI-powered bilingual lyrics")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                Task { await playerVM.authorize() }
            } label: {
                Text("Sign In with Apple Music")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

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

    // MARK: - Main View

    private var mainView: some View {
        VStack(spacing: 0) {
            PlayerBarView()
                .environment(playerVM)

            Divider()

            LyricScrollView()
                .environment(lyricVM)
                .environment(playerVM)
        }
        .background(.windowBackground)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }

            // AI Translate button (only when translatable)
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
        }
    }

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
