import Foundation

// MARK: - LLM Configuration

public struct LLMConfig: Sendable {
    public let apiKey: String
    public let model: String
    public let baseURL: String
    public let maxTokens: Int
    public let temperature: Double
    public let timeoutSeconds: TimeInterval

    public init(
        apiKey: String,
        model: String = "deepseek-chat",
        baseURL: String = "https://api.deepseek.com/v1",
        maxTokens: Int = 4096,
        temperature: Double = 0.3,
        timeoutSeconds: TimeInterval = 30
    ) {
        self.apiKey = apiKey
        self.model = model
        self.baseURL = baseURL
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.timeoutSeconds = timeoutSeconds
    }
}

// MARK: - Chat Message

public struct ChatMessage: Codable, Sendable {
    public let role: String  // "system" | "user" | "assistant"
    public let content: String

    public init(role: String, content: String) {
        self.role = role
        self.content = content
    }
}

// MARK: - Chat Completion

public struct ChatCompletionRequest: Codable, Sendable {
    public let model: String
    public let messages: [ChatMessage]
    public let maxTokens: Int?
    public let temperature: Double?
    public let stream: Bool

    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stream
        case maxTokens = "max_tokens"
    }

    public init(
        model: String,
        messages: [ChatMessage],
        maxTokens: Int? = nil,
        temperature: Double? = nil,
        stream: Bool = false
    ) {
        self.model = model
        self.messages = messages
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.stream = stream
    }
}

public struct ChatCompletionResponse: Codable, Sendable {
    public let id: String
    public let choices: [Choice]
    public let usage: Usage?

    public struct Choice: Codable, Sendable {
        public let index: Int
        public let message: ChatMessage
        public let finishReason: String?

        enum CodingKeys: String, CodingKey {
            case index, message
            case finishReason = "finish_reason"
        }
    }

    public struct Usage: Codable, Sendable {
        public let promptTokens: Int
        public let completionTokens: Int
        public let totalTokens: Int

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

// MARK: - Translation Cache

public struct TranslationCacheEntry: Codable, Sendable {
    public let songId: String
    public let sourceLang: String
    public let targetLang: String
    public let originalLineCount: Int
    public let translatedLines: [LyricLine]
    public let translatedAt: Date
    public let modelUsed: String

    public init(
        songId: String,
        sourceLang: String,
        targetLang: String,
        originalLineCount: Int,
        translatedLines: [LyricLine],
        translatedAt: Date = Date(),
        modelUsed: String
    ) {
        self.songId = songId
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.originalLineCount = originalLineCount
        self.translatedLines = translatedLines
        self.translatedAt = translatedAt
        self.modelUsed = modelUsed
    }
}
