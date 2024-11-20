//
//  Messages.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public struct Messages {
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }

    /// Creates a message using the specified parameters and sends a request to the Anthropic API asynchronously.
    ///
    /// - Parameters:
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Opus`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - tools: The array of `Tool` objects for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    /// - Returns: A `MessagesResponse` object representing the response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue decoding the response.
    public func createMessage(
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
    ) async throws -> MessagesResponse {
        try validate(model, for: messages)

        return try await createMessage(
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

    /// Creates a message using the specified parameters and sends a request to the Anthropic API asynchronously.
    ///
    /// - Parameters:
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Opus`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - tools: The array of `Tool` objects for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    ///   - anthropicHeaderProvider: The provider for the anthropic header NOT required for API authentication.
    ///   - authenticationHeaderProvider: The provider for the authentication header required for API authentication.
    /// - Returns: A `MessagesResponse` object representing the response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue decoding the response.
    public func createMessage(
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
    ) async throws -> MessagesResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = MessagesRequest(
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

        let (data, response) = try await client.send(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try anthropicJSONDecoder.decode(MessagesResponse.self, from: data)
    }

    /// Streams messages using the specified parameters and sends a request to the Anthropic API asynchronously.
    ///
    /// - Parameters:
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Opus`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - tools: The array of `Tool` objects for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    /// - Returns: An asynchronous throwing stream of `StreamingResponse` objects representing the streaming response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue parsing the streaming response.
    public func streamMessage(
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
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error> {
        try validate(model, for: messages)

        return try await streamMessage(
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

    /// Streams messages using the specified parameters and sends a request to the Anthropic API asynchronously.
    ///
    /// - Parameters:
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Opus`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - tools: The array of `Tool` objects for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    ///   - anthropicHeaderProvider: The provider for the anthropic header NOT required for API authentication.
    ///   - authenticationHeaderProvider: The provider for the authentication header required for API authentication.
    /// - Returns: An asynchronous throwing stream of `StreamingResponse` objects representing the streaming response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue parsing the streaming response.
    public func streamMessage(
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
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error> {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = MessagesRequest(
            body: .init(
                model: model,
                messages: messages,
                system: system,
                maxTokens: maxTokens,
                metaData: metaData,
                stopSequences: stopSequence,
                stream: true,
                temperature: temperature,
                topP: topP,
                topK: topK,
                tools: tools,
                toolChoice: toolChoice
            )
        )

        let (data, response) = try await client.stream(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try await AnthropicStreamingParser.parse(stream: data.lines).accumulated()
    }
}

extension Messages {
    func validate(_ model: Model, for messages: [Message]) throws {
        guard (messages.allSatisfy { model.isValid(for: $0) }) else {
            throw ClientError.unsupportedMessageContentContained(
                model: model,
                messages: messages.filter { model.isValid(for: $0) == false }
            )
        }
    }
}
