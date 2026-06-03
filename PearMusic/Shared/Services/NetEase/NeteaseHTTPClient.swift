import Foundation

// MARK: - Signed HTTP Client

/// Typed HTTP client for the NetEase Cloud Music IoT Open Platform API.
///
/// Handles:
/// - Automatic RSA-SHA256 parameter signing
/// - URL encoding of special fields (device, bizContent, sign)
/// - Anonymous token injection
/// - Timestamp management (Beijing time, ±5 min window)
public final class NeteaseHTTPClient: @unchecked Sendable {
    private let baseURL: String
    private let appId: String
    private let privateKeyBase64: String
    private let deviceJSON: String
    private let session: URLSession
    private let NMTIDCookie: String

    public init(
        baseURL: String = "https://openapi.music.163.com",
        appId: String,
        privateKeyBase64: String,
        deviceId: String
    ) {
        self.baseURL = baseURL
        self.appId = appId
        self.privateKeyBase64 = privateKeyBase64
        self.NMTIDCookie = "NMTID=00O8yyemmHtc0HWlk-0sOD1xknkN0IAAAGA7qMrVg"

        let config = NeteaseDeviceConfig(
            deviceType: "openapi",
            os: {
                #if os(macOS)
                return "macos"
                #else
                return "ios"
                #endif
            }(),
            appVer: "1.0.0",
            channel: "pearmusic",
            model: {
                #if os(macOS)
                return "mac"
                #else
                return "iphone"
                #endif
            }(),
            deviceId: deviceId,
            brand: "pearmusic",
            osVer: {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            }(),
            clientIp: "0.0.0.0"
        )
        self.deviceJSON = config.toJSON()

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: sessionConfig)
    }

    // MARK: - Public API

    /// Performs a signed GET request.
    public func get<T: Decodable>(
        path: String,
        bizContent: String = "",
        accessToken: String? = nil
    ) async throws -> T {
        let params = try await buildSignedParams(
            bizContent: bizContent,
            accessToken: accessToken
        )
        let url = buildGetURL(path: path, params: params)
        return try await executeRequest(url: url, method: "GET")
    }

    /// Performs a signed POST request.
    public func post<T: Decodable>(
        path: String,
        bizContent: String = "",
        accessToken: String? = nil
    ) async throws -> T {
        let params = try await buildSignedParams(
            bizContent: bizContent,
            accessToken: accessToken
        )
        let urlString = "\(baseURL)\(path)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let bodyString = params.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        let body = bodyString.data(using: .utf8)

        return try await executeRequest(url: url, method: "POST", body: body)
    }

    // MARK: - Private: Request Building

    private func buildSignedParams(
        bizContent: String,
        accessToken: String?
    ) async throws -> [String: String] {
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))

        // Step 1: Build base params
        var params: [String: String] = [
            "appId": appId,
            "timestamp": timestamp,
            "signType": "RSA_SHA256",
            "device": deviceJSON,
            "bizContent": bizContent,
        ]
        if let token = accessToken {
            params["accessToken"] = token
        }

        // Step 2: Compute signature content
        let content = NeteaseSignature.buildSignContent(params)

        // Step 3: Sign
        let sign = try NeteaseSignature.sign(
            content: content,
            privateKeyBase64: privateKeyBase64
        )

        // Step 4: URL-encode special fields
        let deviceEncoded = NeteaseSignature.encodeURIComponent(deviceJSON)
        let bizEncoded = NeteaseSignature.encodeURIComponent(bizContent)
        let signEncoded = NeteaseSignature.encodeURIComponent(sign)

        // Step 5: Return with encoded values
        var result: [String: String] = [
            "appId": appId,
            "timestamp": timestamp,
            "signType": "RSA_SHA256",
            "device": deviceEncoded,
            "bizContent": bizEncoded,
        ]
        if let token = accessToken {
            result["accessToken"] = token
        }
        result["sign"] = signEncoded

        return result
    }

    private func buildGetURL(
        path: String,
        params: [String: String]
    ) -> URL {
        let sign = params["sign"] ?? ""
        var queryParams = params
        queryParams.removeValue(forKey: "sign")

        let queryString = NeteaseSignature.buildSignContent(queryParams)
        let fullQuery = "\(queryString)&sign=\(sign)"
        let urlString = "\(baseURL)\(path)?\(fullQuery)"

        guard let url = URL(string: urlString) else {
            // Fallback: shouldn't happen since we encode properly
            return URL(string: "\(baseURL)\(path)")!
        }
        return url
    }

    // MARK: - Private: Execution

    private func executeRequest<T: Decodable>(
        url: URL,
        method: String,
        body: Data? = nil
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(NMTIDCookie, forHTTPHeaderField: "Cookie")
        if let body = body {
            request.httpBody = body
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            throw NeteaseAPIError(
                code: httpResponse.statusCode,
                message: "HTTP \(httpResponse.statusCode)"
            )
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)

        // Check API-level error codes for response types that have them
        if let neteaseResp = result as? (any NeteaseResponseProtocol) {
            if neteaseResp.code != 200 {
                throw NeteaseAPIError(code: neteaseResp.code, message: neteaseResp.msg)
            }
        }

        return result
    }
}

// MARK: - Response Protocol

/// Protocol for NetEase API responses that include code/msg fields.
protocol NeteaseResponseProtocol {
    var code: Int { get }
    var msg: String { get }
}

// Conform existing response types
extension AnonymousLoginResponse: NeteaseResponseProtocol {}
extension NeteaseSearchResponse: NeteaseResponseProtocol {}
extension NeteaseLyricResponse: NeteaseResponseProtocol {}
extension WordLyricResponse: NeteaseResponseProtocol {}
