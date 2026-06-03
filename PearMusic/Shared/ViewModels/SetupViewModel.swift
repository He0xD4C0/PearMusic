import Foundation
import SwiftUI

// MARK: - Setup View Model

/// Manages NetEase and AI credential configuration.
/// Credentials are stored securely in Keychain.
@Observable
public final class SetupViewModel {

    // MARK: - Published State

    public var neteaseAppId: String = ""
    public var neteaseAppSecret: String = ""
    public var neteasePrivateKey: String = ""
    public var neteasePublicKey: String = ""
    public var aiApiKey: String = ""
    public var aiModel: String = "deepseek-chat"
    public var aiBaseURL: String = "https://api.deepseek.com/v1"

    public var deviceId: String = ""

    public var showSettings = false
    public var isSaving = false
    public var saveSuccess = false
    public var errorMessage: String?

    // MARK: - Computed

    /// Whether NetEase credentials are fully configured.
    public var isNeteaseConfigured: Bool {
        !neteaseAppId.isEmpty && !neteasePrivateKey.isEmpty
    }

    /// Whether AI translation is configured.
    public var isAIConfigured: Bool {
        !aiApiKey.isEmpty
    }

    // MARK: - Init

    public init() {
        loadFromKeychain()
    }

    // MARK: - Public API

    /// Loads credentials from Keychain.
    public func loadFromKeychain() {
        neteaseAppId = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteaseAppId.rawValue
        ) ?? ""

        neteaseAppSecret = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteaseAppSecret.rawValue
        ) ?? ""

        neteasePrivateKey = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteasePrivateKey.rawValue
        ) ?? ""

        neteasePublicKey = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteasePublicKey.rawValue
        ) ?? ""

        aiApiKey = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.aiApiKey.rawValue
        ) ?? ""

        deviceId = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.deviceId.rawValue
        ) ?? generateDeviceId()
    }

    /// Saves credentials to Keychain.
    public func saveToKeychain() {
        isSaving = true
        errorMessage = nil

        let success = [
            KeychainManager.save(
                service: KeychainManager.pearMusicService,
                account: KeychainManager.Account.neteaseAppId.rawValue,
                value: neteaseAppId
            ),
            KeychainManager.save(
                service: KeychainManager.pearMusicService,
                account: KeychainManager.Account.neteaseAppSecret.rawValue,
                value: neteaseAppSecret
            ),
            KeychainManager.save(
                service: KeychainManager.pearMusicService,
                account: KeychainManager.Account.neteasePrivateKey.rawValue,
                value: neteasePrivateKey
            ),
            KeychainManager.save(
                service: KeychainManager.pearMusicService,
                account: KeychainManager.Account.neteasePublicKey.rawValue,
                value: neteasePublicKey
            ),
            KeychainManager.save(
                service: KeychainManager.pearMusicService,
                account: KeychainManager.Account.aiApiKey.rawValue,
                value: aiApiKey
            ),
        ].allSatisfy { $0 }

        if success {
            saveSuccess = true
            // Reset flag after a delay
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                self.saveSuccess = false
            }
        } else {
            errorMessage = "Failed to save credentials to Keychain."
        }
        isSaving = false
    }

    // MARK: - Private

    private func generateDeviceId() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let id = String((0..<64).compactMap { _ in chars.randomElement() })
        KeychainManager.save(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.deviceId.rawValue,
            value: id
        )
        return id
    }
}
