import Foundation
import Security
import CryptoKit

// MARK: - RSA SHA256 Signature

/// Implements the NetEase API RSA-SHA256 signing algorithm using Security framework.
///
/// Algorithm: RSA PKCS#1 v1.5 with SHA-256 (same as Java's "SHA256WithRSA").
/// Key format: PKCS#8 DER (private), X.509 DER (public), base64-encoded, no PEM headers.
///
/// Uses `SecKeyCreateSignature` with `.rsaSignatureDigestPKCS1v15SHA256` —
/// this is the standard Apple API for RSA-SHA256 and doesn't require the
/// unavailable `RSA` type from CryptoKit.
public enum NeteaseSignature {

    // MARK: - Errors

    public enum SignError: Error, LocalizedError {
        case invalidKey
        case signingFailed(String)
        case importFailed(String)

        public var errorDescription: String? {
            switch self {
            case .invalidKey:
                return "Invalid RSA key format."
            case .signingFailed(let msg):
                return "RSA signing failed: \(msg)"
            case .importFailed(let msg):
                return "Failed to import RSA key: \(msg)"
            }
        }
    }

    // MARK: - Sign

    /// Signs content using RSA-SHA256 with the given PKCS#8 private key (base64, no PEM headers).
    public static func sign(
        content: String,
        privateKeyBase64: String
    ) throws -> String {
        // 1. Decode and import the private key
        let privateKey = try importPrivateKey(base64: privateKeyBase64)

        // 2. Hash content with SHA-256
        let contentData = Data(content.utf8)
        let digest = SHA256.hash(data: contentData)

        // 3. Sign the digest with RSA PKCS#1 v1.5 SHA-256
        var error: Unmanaged<CFError>?
        guard let signatureData = SecKeyCreateSignature(
            privateKey,
            .rsaSignatureDigestPKCS1v15SHA256,
            Data(digest) as CFData,
            &error
        ) else {
            let msg = error?.takeRetainedValue().localizedDescription ?? "Unknown error"
            throw SignError.signingFailed(msg)
        }

        // 4. Return base64-encoded signature
        return (signatureData as Data).base64EncodedString()
    }

    // MARK: - Verify

    /// Verifies a signature using an X.509 public key (base64, no PEM headers).
    public static func verify(
        content: String,
        signatureBase64: String,
        publicKeyBase64: String
    ) throws -> Bool {
        guard let publicKey = try? importPublicKey(base64: publicKeyBase64),
              let sigData = Data(base64Encoded: signatureBase64) else {
            return false
        }

        let contentData = Data(content.utf8)
        let digest = SHA256.hash(data: contentData)

        var error: Unmanaged<CFError>?
        let result = SecKeyVerifySignature(
            publicKey,
            .rsaSignatureDigestPKCS1v15SHA256,
            Data(digest) as CFData,
            sigData as CFData,
            &error
        )

        return result
    }

    // MARK: - Key Import

    private static func importPrivateKey(base64: String) throws -> SecKey {
        let clean = stripWhitespace(base64)
        guard let keyData = Data(base64Encoded: clean) else {
            throw SignError.invalidKey
        }

        // Try PKCS#8 DER import first
        if let key = createPrivateKey(from: keyData) {
            return key
        }

        // Try wrapping in PEM and importing
        let pemKey = wrapInPEM(keyBase64: base64, keyType: "PRIVATE")
        guard pemKey.data(using: .utf8) != nil else {
            throw SignError.importFailed("Cannot convert PEM to data")
        }

        // Strip PEM headers to get raw DER
        let strippedPEM = pemKey
            .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: " ", with: "")

        guard let strippedData = Data(base64Encoded: strippedPEM),
              let key = createPrivateKey(from: strippedData) else {
            throw SignError.importFailed("Cannot create SecKey from provided key data")
        }

        return key
    }

    private static func importPublicKey(base64: String) throws -> SecKey {
        let clean = stripWhitespace(base64)
        guard let keyData = Data(base64Encoded: clean) else {
            throw SignError.invalidKey
        }

        if let key = createPublicKey(from: keyData) {
            return key
        }

        let pemKey = wrapInPEM(keyBase64: base64, keyType: "PUBLIC")
        let strippedPEM = pemKey
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: " ", with: "")

        guard let strippedData = Data(base64Encoded: strippedPEM),
              let key = createPublicKey(from: strippedData) else {
            throw SignError.importFailed("Cannot create SecKey from provided key data")
        }

        return key
    }

    private static func createPrivateKey(from derData: Data) -> SecKey? {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits as String: 2048,
        ]
        return SecKeyCreateWithData(derData as CFData, attributes as CFDictionary, nil)
    }

    private static func createPublicKey(from derData: Data) -> SecKey? {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 2048,
        ]
        return SecKeyCreateWithData(derData as CFData, attributes as CFDictionary, nil)
    }

    // MARK: - Sign Content Builder

    /// Builds the string to be signed from a parameter map.
    ///
    /// Algorithm (matching Java OpenPlatformSignature.getSignCheckContent):
    /// 1. Remove "sign" key if present
    /// 2. Sort remaining keys alphabetically
    /// 3. Join as "key1=value1&key2=value2&..."
    /// 4. NO URL encoding at this stage
    public static func buildSignContent(_ params: [String: String]) -> String {
        let filtered = params.filter { $0.key != "sign" }
        let sorted = filtered.sorted { $0.key < $1.key }
        return sorted.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    }

    // MARK: - URL Encoding

    /// Percent-encodes a string matching Java URIEncoder.encodeURIComponent behavior.
    /// Allowed chars: a-z A-Z 0-9 - _ . ! ~ * ' ( )
    public static func encodeURIComponent(_ input: String) -> String {
        let allowedChars = CharacterSet(charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.!~*'()"
        )
        return input.addingPercentEncoding(withAllowedCharacters: allowedChars) ?? input
    }

    // MARK: - PEM Helpers

    private static func wrapInPEM(keyBase64: String, keyType: String) -> String {
        let clean = keyBase64
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: " ", with: "")

        var result = "-----BEGIN \(keyType) KEY-----\n"
        var i = clean.startIndex
        while i < clean.endIndex {
            let end = clean.index(i, offsetBy: 64, limitedBy: clean.endIndex) ?? clean.endIndex
            result += clean[i..<end] + "\n"
            i = end
        }
        result += "-----END \(keyType) KEY-----"
        return result
    }

    private static func stripWhitespace(_ s: String) -> String {
        s.replacingOccurrences(
            of: "[\\s]",
            with: "",
            options: .regularExpression
        )
    }
}
