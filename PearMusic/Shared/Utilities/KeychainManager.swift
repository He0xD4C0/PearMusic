import Foundation
import Security

/// Secure credential storage using macOS/iOS Keychain.
public enum KeychainManager {

    // MARK: - Save

    /// Saves a value to the Keychain for the given account.
    @discardableResult
    public static func save(
        service: String,
        account: String,
        value: String
    ) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }

        // Try deleting existing entry first
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        // Add new entry
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Load

    /// Loads a value from the Keychain for the given account.
    public static func load(
        service: String,
        account: String
    ) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }

        return string
    }

    // MARK: - Delete

    /// Deletes a value from the Keychain.
    @discardableResult
    public static func delete(
        service: String,
        account: String
    ) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

// MARK: - PearMusic Keychain Keys

public extension KeychainManager {
    static let pearMusicService = "com.pearmusic.keychain"

    enum Account: String {
        case neteaseAppId = "netease_app_id"
        case neteaseAppSecret = "netease_app_secret"
        case neteasePrivateKey = "netease_private_key"
        case neteasePublicKey = "netease_public_key"
        case neteaseAnonymousToken = "netease_anonymous_token"
        case aiApiKey = "ai_api_key"
        case deviceId = "device_id"
    }
}
