//
//  CountTokens.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/13.
//
import Foundation

public struct CountTokens {
    /// The API key used for authentication with the Anthropic API.
    private let apiKey: String
    /// The URL session used for network requests.
    private let session: URLSession

    /// Initializes a new instance of `MessageBatches`.
    ///
    /// - Parameters:
    ///   - apiKey: The API key for authentication.
    ///   - session: The URL session for network requests.
    init(apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }

    public func countTokens(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: [SystemPrompt] = [],
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        tools: [Tool]? = nil,
        toolChoice: ToolChoice = .auto
    ) async throws -> CountTokenResponse {
        try await countTokens(
            messages,
            model: model,
            system: system,
            maxTokens: maxTokens,
            metaData: metaData,
            stopSequence: stopSequence,
            temperature: temperature,
            topP: topP,
            topK: topK,
            tools: tools,
            toolChoice: toolChoice,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func countTokens(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: [SystemPrompt] = [],
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        tools: [Tool]? = nil,
        toolChoice: ToolChoice = .auto,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> CountTokenResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = CountTokenRequest(
            body: .init(
                model: model,
                messages: messages,
                system: system,
                maxTokens: maxTokens,
                metaData: metaData,
                stopSequences: stopSequence,
                stream: false,
                temperature: temperature,
                topP: topP,
                topK: topK,
                tools: tools,
                toolChoice: toolChoice
            )
        )

        return try await client.send(request: request)
    }
}
