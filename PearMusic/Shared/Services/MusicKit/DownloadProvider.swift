import Foundation
import MusicKit

// MARK: - Download Status

public enum DownloadStatus: Sendable, Equatable {
    case notDownloaded
    case downloading(progress: Double)
    case downloaded
    case notEligible
}

// MARK: - Download Provider

/// Manages MusicKit download requests, offline status checks, and
/// offline-mode library filtering.
///
/// MusicKit download is handled at the system level — we check status
/// rather than directly managing the download lifecycle. The system
/// downloads songs automatically when added to the library if the
/// user has enabled Automatic Downloads.
@MainActor
@Observable
public final class DownloadProvider {

    public static let shared = DownloadProvider()

    // MARK: - State

    /// Whether offline-only mode is active (filters library to downloaded).
    public var offlineMode: Bool = false

    /// Whether the user's subscription permits downloads.
    public private(set) var canDownload: Bool = false

    /// Download status cache: song ID → status.
    private var downloadStatusCache: [String: DownloadStatus] = [:]

    /// Set of song IDs that the user has requested to download.
    private var requestedDownloads: Set<String> = []

    public var errorMessage: String?

    // MARK: - Init

    private init() {
        refreshSubscriptionStatus()
    }

    // MARK: - Subscription

    /// Checks whether the current subscription allows downloads.
    public func refreshSubscriptionStatus() {
        Task {
            do {
                let subscription = try await MusicSubscription.current
                canDownload = subscription.canPlayCatalogContent
            } catch {
                canDownload = false
                errorMessage = "Could not verify subscription status."
            }
        }
    }

    // MARK: - Download Status

    /// Queries the system for the download status of a song.
    /// Note: MusicKit's download status APIs are evolving. This provides
    /// best-effort status tracking based on what the SDK exposes.
    public func status(for song: Song) -> DownloadStatus {
        let songId = song.id.rawValue

        // Check cache
        if let cached = downloadStatusCache[songId] {
            return cached
        }

        // Check if user has requested this download
        if requestedDownloads.contains(songId) {
            return .downloading(progress: 0.5) // Intermediate state
        }

        return .notDownloaded
    }

    /// Requests the system to download a song for offline playback.
    /// This adds the song to the library if not already present, which
    /// triggers automatic download when "Automatic Downloads" is enabled.
    public func requestDownload(for song: Song) async throws {
        guard canDownload else {
            throw PearMusicError.downloadNotAvailable
        }

        let songId = song.id.rawValue
        requestedDownloads.insert(songId)
        downloadStatusCache[songId] = .downloading(progress: 0)

        do {
            // Add to library — system handles the actual download
            try await MusicLibrary.shared.add(song)

            // Mark as downloaded (the system manages the actual download)
            downloadStatusCache[songId] = .downloaded
            requestedDownloads.remove(songId)
        } catch {
            downloadStatusCache[songId] = .notEligible
            requestedDownloads.remove(songId)
            throw PearMusicError.downloadFailed(songId: songId, underlying: error)
        }
    }

    /// Requests downloads for multiple songs in parallel.
    public func requestDownloads(for songs: [Song]) async {
        for song in songs {
            do {
                try await requestDownload(for: song)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    /// Removes a song from downloaded status.
    /// In practice, the user manages this via the system Music app.
    public func removeDownload(for song: Song) {
        let songId = song.id.rawValue
        downloadStatusCache[songId] = .notDownloaded
        requestedDownloads.remove(songId)
    }

    // MARK: - Offline Mode

    /// Toggles offline-only mode.
    public func toggleOfflineMode() {
        offlineMode.toggle()
    }

    /// Filters an array of songs to only include downloaded ones.
    /// When offline mode is off, returns all songs unchanged.
    public func filterDownloaded(_ songs: [Song]) -> [Song] {
        guard offlineMode else { return songs }
        return songs.filter { status(for: $0) == .downloaded }
    }

    /// Whether the given song is available for playback in the current mode.
    /// In offline mode, only downloaded songs are available.
    public func isAvailable(_ song: Song) -> Bool {
        guard offlineMode else { return true }
        return status(for: $0) == .downloaded
    }

    /// Clears the download status cache (useful on app restart).
    public func clearCache() {
        downloadStatusCache.removeAll()
    }
}
