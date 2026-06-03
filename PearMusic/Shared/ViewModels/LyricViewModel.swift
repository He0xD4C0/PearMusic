import Foundation
import Combine

// MARK: - Lyric View Model

/// Orchestrates the full lyric flow: search NetEase → fetch lyrics →
/// state machine → AI translation → sync to playback.
@Observable
public final class LyricViewModel {

    // MARK: - State

    public var lyricState: LyricState = .idle
    public var activeLineIndex: Int = -1
    public var currentPlaybackTime: TimeInterval = 0

    // MARK: - Computed

    public var canTranslate: Bool { lyricState.canTranslate }
    public var isTranslating: Bool { lyricState.isTranslating }

    public var lines: [LyricLine]? { lyricState.lines }
    public var errorMessage: String? {
        if case .error(let msg) = lyricState { return msg }
        return nil
    }

    // MARK: - Services

    private let machine = LyricStateMachine()
    private let syncer = LyricSyncer()

    // Configurable clients — set after initialization
    public var neteaseSearchService: NeteaseSearchService?
    public var neteaseLyricService: NeteaseLyricService?
    public var translationPipeline: TranslationPipeline?

    private var currentSongID: String?

    // MARK: - Init

    public init() {
        syncer.onLineChange = { [weak self] index, _ in
            Task { @MainActor in
                self?.activeLineIndex = index
            }
        }
        syncer.onTick = { [weak self] time in
            Task { @MainActor in
                self?.currentPlaybackTime = time
            }
        }
    }

    // MARK: - Public API

    /// Fetches lyrics for a song from NetEase and processes them.
    public func fetchLyrics(
        artist: String,
        title: String
    ) async {
        lyricState = .loading
        let songID = "\(artist):\(title)"
        currentSongID = songID

        guard let search = neteaseSearchService,
              let lyric = neteaseLyricService else {
            lyricState = .error(message: "NetEase services not configured. Add your keys in Settings.")
            return
        }

        do {
            // Step 1: Search NetEase for matching songId
            guard let songId = try await search.findBestMatch(
                artist: artist,
                song: title
            ) else {
                lyricState = .unavailable
                return
            }

            guard currentSongID == songID else { return } // Song changed

            // Step 2: Fetch lyrics
            let response = try await lyric.getLyric(songId: songId)

            guard currentSongID == songID else { return }

            guard response.code == 200, let data = response.data else {
                machine.process(noLyric: false, lyric: nil, transLyric: nil)
                lyricState = machine.state
                return
            }

            // Step 3: Process through state machine
            machine.process(
                noLyric: data.noLyric,
                lyric: data.lyric,
                transLyric: data.transLyric
            )
            lyricState = machine.state

            // Step 4: Start syncer if we have lyrics
            if machine.shouldSync, let lines = machine.lines {
                syncer.setLines(lines)
                syncer.start {
                    PlaybackEngine.shared.currentPlaybackTime
                }
            }
        } catch {
            guard currentSongID == songID else { return }
            lyricState = .error(message: error.localizedDescription)
        }
    }

    /// Triggers AI translation for the current song.
    public func triggerTranslation() async {
        guard let pipeline = translationPipeline else {
            lyricState = .error(message: "AI translation not configured. Add your API key in Settings.")
            return
        }

        guard let lines = machine.triggerAITranslation() else { return }
        lyricState = machine.state

        do {
            let translated = try await pipeline.translate(
                songId: currentSongID ?? "unknown",
                lines: lines
            )
            machine.completeAITranslation(lines: translated)
            lyricState = machine.state

            // Update syncer with translated lines
            if machine.shouldSync, let newLines = machine.lines {
                syncer.setLines(newLines)
            }
        } catch {
            machine.failTranslation(message: error.localizedDescription)
            lyricState = machine.state
        }
    }

    /// Stops the syncer and resets state (e.g., when nothing is playing).
    public func reset() {
        syncer.stop()
        machine.reset()
        lyricState = .idle
        activeLineIndex = -1
        currentSongID = nil
    }
}
