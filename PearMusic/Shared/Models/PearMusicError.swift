import Foundation

// MARK: - PearMusic Error Types

/// Centralized error types for all PearMusic subsystems.
/// Conforms to `LocalizedError` for user-facing message support.
public enum PearMusicError: Error, LocalizedError, Sendable {

    // MARK: - MusicKit Authorization

    case musicKitNotAuthorized
    case musicKitRestricted
    case musicKitDenied

    // MARK: - Playback

    case playbackFailed(underlying: Error)
    case noActiveQueue
    case queueEmpty
    case songUnavailable(id: String)

    // MARK: - Search

    case searchFailed(underlying: Error)
    case searchNoResults(query: String)

    // MARK: - Library

    case libraryAccessDenied
    case playlistNotFound(id: String)
    case playlistEditFailed(underlying: Error)
    case trackAddFailed(songId: String, playlistId: String)

    // MARK: - Downloads

    case downloadNotAvailable
    case downloadFailed(songId: String, underlying: Error)
    case downloadStatusUnknown(songId: String)

    // MARK: - NetEase Bridge

    case neteaseConfigMissing
    case neteaseAuthFailed(code: Int, message: String)
    case neteaseSearchFailed(underlying: Error)
    case lyricNotFound(artist: String, title: String)

    // MARK: - AI Translation

    case translationFailed(underlying: Error)
    case translationNotConfigured
    case aiApiError(statusCode: Int, message: String)
    case aiRateLimited(retryAfter: TimeInterval?)

    // MARK: - Secrets / Keychain

    case keychainError(operation: String)
    case secretsMissing(key: String)

    // MARK: - General

    case unknown(underlying: Error)

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        // Authorization
        case .musicKitNotAuthorized:
            return "Apple Music access is required."
        case .musicKitRestricted:
            return "Apple Music access is restricted on this device."
        case .musicKitDenied:
            return "Apple Music access was denied. Enable it in System Settings."

        // Playback
        case .playbackFailed(let error):
            return "Playback failed: \(error.localizedDescription)"
        case .noActiveQueue:
            return "Nothing is queued for playback."
        case .queueEmpty:
            return "The playback queue is empty."
        case .songUnavailable(let id):
            return "Song unavailable (\(id))."

        // Search
        case .searchFailed(let error):
            return "Search failed: \(error.localizedDescription)"
        case .searchNoResults(let query):
            return "No results found for \"\(query)\"."

        // Library
        case .libraryAccessDenied:
            return "Cannot access your music library."
        case .playlistNotFound(let id):
            return "Playlist not found (\(id))."
        case .playlistEditFailed(let error):
            return "Failed to edit playlist: \(error.localizedDescription)"
        case .trackAddFailed(let songId, let playlistId):
            return "Failed to add track \(songId) to playlist \(playlistId)."

        // Downloads
        case .downloadNotAvailable:
            return "Downloads require an Apple Music subscription."
        case .downloadFailed(let songId, let error):
            return "Download failed for song \(songId): \(error.localizedDescription)"
        case .downloadStatusUnknown(let songId):
            return "Could not determine download status for song \(songId)."

        // NetEase
        case .neteaseConfigMissing:
            return "NetEase API credentials not configured."
        case .neteaseAuthFailed(let code, let message):
            return "NetEase authentication failed [\(code)]: \(message)"
        case .neteaseSearchFailed(let error):
            return "NetEase search failed: \(error.localizedDescription)"
        case .lyricNotFound(let artist, let title):
            return "No lyrics found for \"\(title)\" by \(artist)."

        // AI
        case .translationFailed(let error):
            return "AI translation failed: \(error.localizedDescription)"
        case .translationNotConfigured:
            return "AI translation not configured. Add your API key in Settings."
        case .aiApiError(let statusCode, let message):
            return "AI API error [\(statusCode)]: \(message)"
        case .aiRateLimited(let retryAfter):
            if let seconds = retryAfter {
                return "AI rate limited. Retry in \(Int(seconds)) seconds."
            }
            return "AI rate limited. Please try again later."

        // Secrets
        case .keychainError(let operation):
            return "Keychain error during \(operation)."
        case .secretsMissing(let key):
            return "Required secret not found: \(key)"

        // General
        case .unknown(let error):
            return "Unexpected error: \(error.localizedDescription)"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .musicKitNotAuthorized:
            return "Tap \"Sign In with Apple Music\" to authorize."
        case .musicKitRestricted:
            return "Contact your device administrator or check Screen Time restrictions."
        case .musicKitDenied:
            return "Open System Settings → Privacy → Media & Apple Music, then enable PearMusic."
        case .playbackFailed:
            return "Try playing another song or restart the app."
        case .noActiveQueue, .queueEmpty:
            return "Search for a song and tap play to begin."
        case .songUnavailable:
            return "This song may have been removed from the catalog."
        case .searchFailed:
            return "Check your internet connection and try again."
        case .searchNoResults:
            return "Try a different search term."
        case .libraryAccessDenied:
            return "Grant library access in System Settings → Privacy → Media & Apple Music."
        case .playlistNotFound:
            return "This playlist may have been deleted."
        case .playlistEditFailed:
            return "Check your Apple Music subscription status."
        case .trackAddFailed:
            return "Check that the song is available in your region."
        case .downloadNotAvailable:
            return "Subscribe to Apple Music to enable offline downloads."
        case .downloadFailed:
            return "Check your internet connection and available storage."
        case .downloadStatusUnknown:
            return "Try refreshing your library."
        case .neteaseConfigMissing:
            return "Open Settings and enter your NetEase API credentials."
        case .neteaseAuthFailed:
            return "Check your NetEase App ID and private key in Settings."
        case .neteaseSearchFailed:
            return "Check your internet connection. NetEase services may be unavailable."
        case .lyricNotFound:
            return "Try using AI translation on the original lyrics if available."
        case .translationFailed:
            return "The AI service may be temporarily unavailable. Try again later."
        case .translationNotConfigured:
            return "Open Settings and enter your AI provider API key."
        case .aiApiError:
            return "Check your API key and model name in Settings."
        case .aiRateLimited:
            return "Wait a moment before requesting another translation."
        case .keychainError:
            return "Try re-entering your credentials in Settings."
        case .secretsMissing:
            return "Check the Secrets.plist configuration."
        case .unknown:
            return "Please try again or contact support."
        }
    }

    /// Converts any Error into a PearMusicError, wrapping unknown errors.
    public static func wrap(_ error: Error) -> PearMusicError {
        if let pear = error as? PearMusicError {
            return pear
        }
        return .unknown(underlying: error)
    }
}
