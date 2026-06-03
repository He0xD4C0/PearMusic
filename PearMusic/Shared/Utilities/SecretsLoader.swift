import Foundation

// MARK: - Secrets Loader

/// Loads API keys and credentials from Secrets.plist (gitignored) with
/// Keychain fallback. The plist provides defaults; Keychain stores user
/// overrides from the Settings UI.
public enum SecretsLoader {

    // MARK: - Types

    public struct NeteaseSecrets: Sendable {
        public let appId: String
        public let privateKeyBase64: String
        public let publicKeyBase64: String?
    }

    public struct AISecrets: Sendable {
        public let apiKey: String
        public let model: String
        public let baseURL: String
    }

    // MARK: - Errors

    enum LoadError: Error {
        case plistNotFound
        case malformedPlist
        case missingKey(String)
    }

    // MARK: - Load from Plist

    private static func plist() -> [String: Any]? {
        guard let url = Bundle.main.url(
            forResource: "Secrets",
            withExtension: "plist"
        ) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(
                from: data,
                format: nil
              ) as? [String: Any] else {
            return nil
        }
        return plist
    }

    // MARK: - NetEase

    /// Loads NetEase credentials, preferring Keychain overrides over plist defaults.
    public static func loadNeteaseSecrets() -> NeteaseSecrets? {
        // Prefer Keychain user overrides
        let appId = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteaseAppId.rawValue
        )
        let privateKey = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteasePrivateKey.rawValue
        )
        let publicKey = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteasePublicKey.rawValue
        )

        if let appId, let privateKey {
            return NeteaseSecrets(
                appId: appId,
                privateKeyBase64: privateKey,
                publicKeyBase64: publicKey
            )
        }

        // Fall back to plist defaults
        guard let plist = plist(),
              let netease = plist["Netease"] as? [String: Any],
              let plistAppId = netease["appId"] as? String,
              let plistPrivateKey = netease["privateKeyBase64"] as? String,
              plistAppId != "YOUR_NETEASE_APP_ID" else {
            return nil
        }

        return NeteaseSecrets(
            appId: plistAppId,
            privateKeyBase64: plistPrivateKey,
            publicKeyBase64: netease["publicKeyBase64"] as? String
        )
    }

    // MARK: - AI

    /// Loads AI provider credentials, preferring Keychain overrides.
    public static func loadAISecrets() -> AISecrets? {
        // Prefer Keychain user overrides
        let apiKey = KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.aiApiKey.rawValue
        )

        if let apiKey {
            return AISecrets(
                apiKey: apiKey,
                model: "deepseek-chat",
                baseURL: "https://api.deepseek.com/v1"
            )
        }

        // Fall back to plist defaults
        guard let plist = plist(),
              let ai = plist["AI"] as? [String: Any],
              let plistApiKey = ai["apiKey"] as? String,
              plistApiKey != "YOUR_AI_API_KEY" else {
            return nil
        }

        return AISecrets(
            apiKey: plistApiKey,
            model: ai["model"] as? String ?? "deepseek-chat",
            baseURL: ai["baseURL"] as? String ?? "https://api.deepseek.com/v1"
        )
    }
}
