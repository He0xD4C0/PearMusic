import Foundation

// MARK: - Anonymous Token Manager

/// Manages the NetEase anonymous authentication token lifecycle.
///
/// Key properties (from API docs):
/// - Token is tied to the deviceId — one token per device
/// - Token is permanent and never expires
/// - Cached securely in Keychain
public final class NeteaseAuth: Sendable {
    private let deviceId: String

    public init(deviceId: String) {
        self.deviceId = deviceId
    }

    // MARK: - Public API

    /// Returns the anonymous access token, fetching from cache or performing login.
    public func getAnonymousToken(
        httpClient: NeteaseHTTPClient
    ) async throws -> String {
        // 1. Check Keychain cache
        if let cached = loadCachedToken() {
            return cached
        }

        // 2. Perform anonymous login
        return try await performAnonymousLogin(httpClient: httpClient)
    }

    /// Forces a fresh login, discarding any cached token.
    public func refreshToken(
        httpClient: NeteaseHTTPClient
    ) async throws -> String {
        clearCachedToken()
        return try await performAnonymousLogin(httpClient: httpClient)
    }

    /// Returns the deviceId.
    public func getDeviceId() -> String { deviceId }

    // MARK: - Private

    private func performAnonymousLogin(
        httpClient: NeteaseHTTPClient
    ) async throws -> String {
        let bizContent = #"{"clientId":""}"#

        let response: AnonymousLoginResponse = try await httpClient.get(
            path: "/openapi/music/basic/oauth2/login/anonymous",
            bizContent: bizContent
        )

        guard response.code == 200,
              let token = response.data?.accessToken else {
            throw NeteaseAPIError(
                code: response.code,
                message: response.msg
            )
        }

        persistToken(token)
        return token
    }

    // MARK: - Keychain Persistence

    private func loadCachedToken() -> String? {
        KeychainManager.load(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteaseAnonymousToken.rawValue
        )
    }

    private func persistToken(_ token: String) {
        KeychainManager.save(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteaseAnonymousToken.rawValue,
            value: token
        )
    }

    private func clearCachedToken() {
        KeychainManager.delete(
            service: KeychainManager.pearMusicService,
            account: KeychainManager.Account.neteaseAnonymousToken.rawValue
        )
    }
}
