//
//  Messages.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

// swiftlint:disable file_length

import Foundation
import FunctionCalling

// swiftlint:disable:next type_body_length
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
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    /// - Returns: A `MessagesResponse` object representing the response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue decoding the response.
    public func createMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto
    ) async throws -> MessagesResponse {
        try await createMessage(
            messages,
            model: model,
            system: system,
            maxTokens: maxTokens,
            metaData: metaData,
            stopSequence: stopSequence,
            temperature: temperature,
            topP: topP,
            topK: topK,
            toolContainer: toolContainer,
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
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    ///   - anthropicHeaderProvider: The provider for the anthropic header NOT required for API authentication.
    ///   - authenticationHeaderProvider: The provider for the authentication header required for API authentication.
    /// - Returns: A `MessagesResponse` object representing the response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue decoding the response.
    public func createMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> MessagesResponse {
        let client = AnthropicAPIClient(
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider,
            session: session
        )

        let requestBody = MessagesRequest(
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
            tools: toolContainer?.allTools,
            toolChoice: toolChoice
        )

        let (data, response) = try await client.send(requestBody: requestBody)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        let result = try anthropicJSONDecoder.decode(MessagesResponse.self, from: data)

        guard case .toolUse = result.stopReason else {
            return result
        }

        return try await sendToolResult(
            forToolUseRequest: result,
            priviousMessages: messages,
            model: model,
            system: system,
            maxTokens: maxTokens,
            metaData: metaData,
            stopSequence: stopSequence,
            temperature: temperature,
            topP: topP,
            topK: topK,
            toolContainer: toolContainer,
            toolChoice: toolChoice,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )
    }

    /// Return the result of tool execution back to the model as a user message
    ///
    /// - Parameters:
    ///   - toolUseRequest: Message response from API to execute tools with arguments.
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Opus`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    ///   - anthropicHeaderProvider: The provider for the anthropic header NOT required for API authentication.
    ///   - authenticationHeaderProvider: The provider for the authentication header required for API authentication.
    /// - Returns: A `MessagesResponse` object representing the response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue decoding the response.
    func sendToolResult(
        forToolUseRequest toolUseRequest: MessagesResponse,
        priviousMessages messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> MessagesResponse {
        // If a `tool_use` response is returned with no `ToolContainer` specified, `tool_use_result` cannot be returned because any tool does not exist.
        guard let toolContainer else {
            throw ClientError.anyToolsAreDefined
        }

        guard case .toolUse(let toolUseContent) = toolUseRequest.content.first(where: { $0.contentType == .toolUse }) else {
            throw ClientError.cannotFindToolUseContentFromResponse(toolUseRequest)
        }

        let toolResult = await toolContainer.execute(methodName: toolUseContent.name, parameters: toolUseContent.input)
        let toolResultRequest = messages + [
            .init(role: .assistant, content: [.toolUse(toolUseContent)]),
            .init(role: .user, content: [.toolResult(.init(toolUseId: toolUseContent.id, content: [.text(toolResult)], isError: nil))])
        ]

        return try await createMessage(
            toolResultRequest,
            model: model,
            system: system,
            maxTokens: maxTokens,
            metaData: metaData,
            stopSequence: stopSequence,
            temperature: temperature,
            topP: topP,
            topK: topK,
            toolContainer: toolContainer,
            toolChoice: toolChoice,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
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
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    /// - Returns: An asynchronous throwing stream of `StreamingResponse` objects representing the streaming response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue parsing the streaming response.
    public func streamMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error> {
        try await streamMessage(
            messages,
            model: model,
            system: system,
            maxTokens: maxTokens,
            metaData: metaData,
            stopSequence: stopSequence,
            temperature: temperature,
            topP: topP,
            topK: topK,
            toolContainer: toolContainer,
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
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    ///   - anthropicHeaderProvider: The provider for the anthropic header NOT required for API authentication.
    ///   - authenticationHeaderProvider: The provider for the authentication header required for API authentication.
    /// - Returns: An asynchronous throwing stream of `StreamingResponse` objects representing the streaming response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue parsing the streaming response.
    public func streamMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error> {
        let client = AnthropicAPIClient(
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider,
            session: session
        )

        let requestBody = MessagesRequest(
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
            tools: toolContainer?.allTools,
            toolChoice: toolChoice
        )

        let (data, response) = try await client.stream(requestBody: requestBody)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return resendStreamMessageIfClaudeRequestsToolUse(
            try await AnthropicStreamingParser.parse(stream: data.lines).accumulated(),
            messages: messages,
            model: model,
            system: system,
            maxTokens: maxTokens,
            metaData: metaData,
            stopSequence: stopSequence,
            temperature: temperature,
            topP: topP,
            topK: topK,
            toolContainer: toolContainer,
            toolChoice: toolChoice,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )
    }

    /// Receive response from Claude in Stream format.
    ///
    /// If there is a response related to `tool_use`, the information is compiled and streamed.
    ///
    /// - Parameters:
    ///   - stream: response stream from Claude Stream API
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Opus`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`
    ///   - anthropicHeaderProvider: The provider for the anthropic header NOT required for API authentication.
    ///   - authenticationHeaderProvider: The provider for the authentication header required for API authentication.
    /// - Returns: Claude Stream API response stream. If `stream` returns `tool_use` content, this method returns re-request new stream.
    // swiftlint:disable:next function_parameter_count
    func resendStreamMessageIfClaudeRequestsToolUse(
        _ stream: AsyncThrowingStream<StreamingResponse, Error>,
        messages: [Message],
        model: Model,
        system: String?,
        maxTokens: Int,
        metaData: MetaData?,
        stopSequence: [String]?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        toolContainer: ToolContainer?,
        toolChoice: ToolChoice,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) -> AsyncThrowingStream<StreamingResponse, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    for try await response in stream {
                        if
                            let toolContainer,
                            let deltaResponse = response as? StreamingMessageDeltaResponse,
                            let toolUseContent = deltaResponse.toolUseContent,
                            let toolResultContent = await deltaResponse.getToolResultContent(from: toolContainer),
                            response.isToolUse {
                            let streamWithToolResult = try await streamMessage(
                                messages + [
                                    .init(role: .assistant, content: [.toolUse(toolUseContent)]),
                                    .init(role: .user, content: [toolResultContent])
                                ],
                                model: model,
                                system: system,
                                maxTokens: maxTokens,
                                metaData: metaData,
                                stopSequence: stopSequence,
                                temperature: temperature,
                                topP: topP,
                                topK: topK,
                                toolContainer: toolContainer,
                                toolChoice: toolChoice,
                                anthropicHeaderProvider: anthropicHeaderProvider,
                                authenticationHeaderProvider: authenticationHeaderProvider
                            )

                            for try await responseWithToolResult in streamWithToolResult {
                                continuation.yield(responseWithToolResult)
                            }
                        } else {
                            continuation.yield(response)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

// swiftlint:enable file_length
