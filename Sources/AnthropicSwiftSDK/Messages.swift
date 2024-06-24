//
//  Messages.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation
import FunctionCallingService

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
        // TODO: write tests
        guard let toolContainer else {
            // TODO: Throw error
            fatalError("Claude returns tool_use but any tools are defined")
        }

        guard case .toolUse(let toolUseContent) = toolUseRequest.content.first(where: { $0.contentType == .toolUse }) else {
            fatalError("TODO: Throw error")
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

        return try await AnthropicStreamingParser.parse(stream: data.lines)
    }

    // TODO: Streamingの方は既存のインターフェースは変えずに `AsyncThrowingStream<StreamingResponse, Error>` を受け取って `StreamingResponse` を返す & `input_json_delta` の場合は集約して"type":"message_delta","delta":{"stop_reason":"tool_use"のタイミングで `ToolUseContent` を返すやつを追加する
    // stream -> accumulated -> toolUseがあったら -> stream
}

extension AsyncThrowingStream where Element == StreamingResponse {
    func accumulated() throws -> AsyncThrowingStream<JSONDeltaAccumulator.AccumulatedResult, Error> {
        let accumulator = JSONDeltaAccumulator()
        let accumulatedStream = accumulator.getAccumulatedStream()

        Task {
            do {
                for try await value in self {
                    try accumulator.accumulateIfNeeded(value)
                }
            } catch {
                accumulator.finish()
                throw error
            }
        }

        return accumulatedStream
    }
}

class JSONDeltaAccumulator {
    typealias AccumulatedResult = (StreamingResponse, ToolUseContent?)
    private var jsonDelta: [StreamingContentBlockDeltaResponse] = []
    private var streamingResponseStream: AsyncThrowingStream<AccumulatedResult, Error>.Continuation?

    // TODO: rename
    func accumulateIfNeeded(_ response: StreamingResponse) throws {
        var toolUseContent: ToolUseContent?

        switch response {
        case let res as StreamingContentBlockDeltaResponse:
            // TODO: define delta type and content
            if res.delta.type == .inputJSON {
                jsonDelta.append(res)
            }
        case let res as StreamingMessageDeltaResponse:
            if res.delta.stopReason == .toolUse {
                toolUseContent = try createToolUseContent(from: jsonDelta)
            }
        default:
            break
        }

        streamingResponseStream?.yield((response, toolUseContent))
    }


    func createToolUseContent(from delta: [StreamingContentBlockDeltaResponse]) throws -> ToolUseContent {
        fatalError("TODO: ")
    }

    func getAccumulatedStream() -> AsyncThrowingStream<AccumulatedResult, Error> {
        AsyncThrowingStream { continuation in
            self.streamingResponseStream = continuation
        }
    }

    func finish() {
        streamingResponseStream?.finish()
    }
}
