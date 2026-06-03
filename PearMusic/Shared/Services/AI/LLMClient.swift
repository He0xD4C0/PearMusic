import Foundation

// MARK: - LLM Client

/// OpenAI-compatible LLM API client with exponential backoff retry.
public final class LLMClient: Sendable {
    private let config: LLMConfig
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    public init(config: LLMConfig) {
        self.config = config
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = config.timeoutSeconds
        self.session = URLSession(configuration: sessionConfig)
    }

    // MARK: - Public API

    /// Sends a prompt and returns the completion text.
    public func complete(
        userPrompt: String,
        systemPrompt: String? = nil
    ) async throws -> String {
        var messages: [ChatMessage] = []

        if let sys = systemPrompt {
            messages.append(ChatMessage(role: "system", content: sys))
        }
        messages.append(ChatMessage(role: "user", content: userPrompt))

        return try await chat(messages: messages)
    }

    /// Sends a chat completion request.
    public func chat(messages: [ChatMessage]) async throws -> String {
        let request = ChatCompletionRequest(
            model: config.model,
            messages: messages,
            maxTokens: config.maxTokens,
            temperature: config.temperature,
            stream: false
        )

        return try await sendWithRetry(request, retries: 3)
    }

    // MARK: - Private

    private func sendWithRetry(
        _ request: ChatCompletionRequest,
        retries: Int
    ) async throws -> String {
        var lastError: Error?

        for attempt in 0...retries {
            do {
                return try await send(request)
            } catch {
                lastError = error
                if attempt < retries {
                    // Exponential backoff: 1s, 2s, 4s
                    let delay = Double(1 << attempt)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }

        throw lastError ?? URLError(.unknown)
    }

    private func send(_ request: ChatCompletionRequest) async throws -> String {
        let url = URL(string: "\(config.baseURL)/chat/completions")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")

        let body = try encoder.encode(request)
        urlRequest.httpBody = body

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(
                domain: "LLMClient",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: errorBody]
            )
        }

        let completion = try decoder.decode(ChatCompletionResponse.self, from: data)

        guard let choice = completion.choices.first else {
            throw NSError(
                domain: "LLMClient",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No completion choice returned"]
            )
        }

        return choice.message.content
    }
}
