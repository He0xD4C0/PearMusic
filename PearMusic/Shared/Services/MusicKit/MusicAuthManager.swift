import Foundation
import MusicKit
import SwiftUI
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

// MARK: - Music Authorization Manager

/// Dedicated handler for MusicKit authorization lifecycle.
///
/// Separated from playback logic so denied/restricted states
/// can be handled with dedicated UI fallbacks before the player
/// subsystem is even initialized.
///
/// All methods are `@MainActor` because `MusicAuthorization` requires it.
@MainActor
@Observable
public final class MusicAuthManager {

    public static let shared = MusicAuthManager()

    // MARK: - State

    /// The current authorization status.
    public private(set) var status: MusicAuthorization.Status = .notDetermined

    /// Whether the auth dialog has been shown at least once.
    public private(set) var hasRequestedAuthorization = false

    /// User-facing status message for the current state.
    public var statusMessage: String {
        switch status {
        case .notDetermined:
            return "Apple Music access is required to play songs and display synced lyrics."
        case .authorized:
            return "Apple Music authorized."
        case .denied:
            return "Apple Music access was denied. Enable it in System Settings → Privacy → Media & Apple Music."
        case .restricted:
            return "Apple Music access is restricted on this device. Check Screen Time or device management settings."
        @unknown default:
            return "Unknown authorization state."
        }
    }

    /// System symbol name matching the current state.
    public var statusSymbol: String {
        switch status {
        case .notDetermined: return "music.note"
        case .authorized:    return "music.note.house.fill"
        case .denied:        return "music.note.slash"
        case .restricted:    return "lock.shield"
        @unknown default:    return "questionmark"
        }
    }

    // MARK: - Computed

    public var isAuthorized: Bool { status == .authorized }
    public var isDenied: Bool { status == .denied }
    public var isRestricted: Bool { status == .restricted }
    public var needsAuthorization: Bool { status != .authorized }

    // MARK: - Authorization Actions

    /// Checks the current authorization status without prompting the user.
    @discardableResult
    public func checkStatus() -> MusicAuthorization.Status {
        status = MusicAuthorization.currentStatus
        return status
    }

    /// Requests Apple Music authorization from the user.
    ///
    /// On first call, this triggers the system authorization dialog.
    /// Subsequent calls return the current status immediately.
    ///
    /// - Returns: The authorization status after the request.
    @discardableResult
    public func requestAuthorization() async -> MusicAuthorization.Status {
        hasRequestedAuthorization = true
        status = await MusicAuthorization.request()
        return status
    }

    /// Opens System Settings so the user can manually enable Apple Music access.
    /// Only relevant when the status is `.denied`.
    public func openSystemSettings() {
        #if os(macOS)
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Media") {
            NSWorkspace.shared.open(url)
        }
        #elseif os(iOS)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
        #endif
    }

    // MARK: - Initialization

    private init() {
        self.status = MusicAuthorization.currentStatus
    }
}
