import Foundation
import CryptoKit

// MARK: - RSA SHA256 Signature

/// Implements the NetEase API RSA-SHA256 signing algorithm using CryptoKit.
///
/// Algorithm: RSA PKCS#1 v1.5 with SHA-256 (same as Java's "SHA256WithRSA").
/// Key format: PKCS#8 DER (private), X.509 DER (public), base64-encoded, no PEM headers.
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
        // 1. Decode base64 key
        guard let keyData = Data(base64Encoded: stripWhitespace(privateKeyBase64)) else {
            throw SignError.invalidKey
        }

        // 2. Import as RSA private key
        let privateKey: RSA.Signing.PrivateKey
        do {
            privateKey = try RSA.Signing.PrivateKey(derRepresentation: keyData)
        } catch {
            // Try wrapping in PEM format and re-importing
            let pemKey = wrapInPEM(keyBase64: privateKeyBase64, keyType: "PRIVATE")
            guard let pemData = pemKey.data(using: .utf8),
                  let importedKey = try? RSA.Signing.PrivateKey(pemRepresentation: pemData) else {
                throw SignError.importFailed(error.localizedDescription)
            }
            privateKey = importedKey
        }

        // 3. Sign with SHA-256 (PKCS#1 v1.5 padding)
        let contentData = Data(content.utf8)
        let signature: RSA.Signing.RSASignature
        do {
            signature = try privateKey.sign(
                .SHA256,
                data: contentData,
                padding: .PKCS1
            )
        } catch {
            throw SignError.signingFailed(error.localizedDescription)
        }

        // 4. Return base64 signature
        return signature.rawRepresentation.base64EncodedString()
    }

    /// Signs content using the async-friendly wrapper (same implementation).
    public static func signAsync(
        content: String,
        privateKeyBase64: String
    ) async throws -> String {
        try sign(content: content, privateKeyBase64: privateKeyBase64)
    }

    // MARK: - Verify

    /// Verifies a signature using an X.509 public key (base64, no PEM headers).
    public static func verify(
        content: String,
        signatureBase64: String,
        publicKeyBase64: String
    ) throws -> Bool {
        guard let keyData = Data(base64Encoded: stripWhitespace(publicKeyBase64)),
              let sigData = Data(base64Encoded: signatureBase64) else {
            return false
        }

        let publicKey: RSA.Signing.PublicKey
        do {
            publicKey = try RSA.Signing.PublicKey(derRepresentation: keyData)
        } catch {
            let pemKey = wrapInPEM(keyBase64: publicKeyBase64, keyType: "PUBLIC")
            guard let pemData = pemKey.data(using: .utf8),
                  let importedKey = try? RSA.Signing.PublicKey(pemRepresentation: pemData) else {
                return false
            }
            publicKey = importedKey
        }

        let contentData = Data(content.utf8)
        let signature = RSA.Signing.RSASignature(rawRepresentation: sigData)
        return publicKey.isValidSignature(signature, for: .SHA256, data: contentData, padding: .PKCS1)
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
        let clean = keyBase64.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: " ", with: "")

        var result = "-----BEGIN \(keyType) KEY-----\n"
        for i in stride(from: 0, to: clean.count, by: 64) {
            let end = min(i + 64, clean.count)
            let startIdx = clean.index(clean.startIndex, offsetBy: i)
            let endIdx = clean.index(clean.startIndex, offsetBy: end)
            result += clean[startIdx..<endIdx] + "\n"
        }
        result += "-----END \(keyType) KEY-----"
        return result
    }

    private static func stripWhitespace(_ s: String) -> String {
        s.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    }
}
