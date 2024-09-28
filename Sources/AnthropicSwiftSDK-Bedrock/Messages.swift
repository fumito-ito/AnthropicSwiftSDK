//
//  Messages.swift
//
//
//  Created by 伊藤史 on 2024/03/22.
//

import Foundation
import AnthropicSwiftSDK
import AWSBedrockRuntime
import FunctionCalling

public struct Messages {
    /// Acceptable content type for response
    public let acceptContentType = "application/json"
    /// Acceptable content type for request
    public let requestContentType = "application/json"
    /// Bedrock API Client
    public let client: BedrockRuntimeClient

    init(client: BedrockRuntimeClient) {
        self.client = client
    }

    /// Creates a message using the specified parameters and sends a request to the Anthropic API asynchronously.
    ///
    /// - Parameters:
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Haiku`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`. This property is defined but not used for Bedrock.
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`.  This property is defined but not used for Bedrock.
    /// - Returns: A `MessagesResponse` object representing the response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue decoding the response.
    public func createMessage(
        _ messages: [Message],
        model: Model = .claude_3_Haiku,
        system: [SystemPrompt] = [],
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto
    ) async throws -> MessagesResponse {
        // In the inference call, fill the body field with a JSON object that conforms the type call you want to make [Anthropic Claude Messages API](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html).
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
            topK: topK
        )

        let input = try InvokeModelInput(
            accept: acceptContentType,
            request: requestBody,
            contentType: requestContentType
        )

        let response = try await client.invokeModel(input: input)

        return try MessagesResponse(from: response)
    }

    /// Streams messages using the specified parameters and sends a request to the Anthropic API asynchronously.
    ///
    /// - Parameters:
    ///   - messages: An array of Message objects representing the input prompt for message generation.
    ///   - model: The model to be used for generating the message. Default is `.claude_3_Haiku`.
    ///   - system: The system identifier. Default is `nil`.
    ///   - maxTokens: The maximum number of tokens in the generated message.
    ///   - metaData: Additional metadata for the request. Default is `nil`.
    ///   - stopSequence: An array of strings representing sequences where the message generation should stop.
    ///   - temperature: The temperature parameter controls the randomness of the generated text. Default is `nil`.
    ///   - topP: The nucleus sampling parameter. Default is `nil`.
    ///   - topK: The top-k sampling parameter. Default is `nil`.
    ///   - toolContainer: The tool provider for `tool_use`. Default is `nil`. This property is defined but not used for Bedrock.
    ///   - toolChoice: The parameter for tool choice. Default is `.auto`.  This property is defined but not used for Bedrock.
    /// - Returns: An asynchronous throwing stream of `StreamingResponse` objects representing the streaming response from the Anthropic API.
    /// - Throws: An error if the request fails or if there's an issue parsing the streaming response.
    public func streamMessage(
        _ messages: [Message],
        model: Model = .claude_3_Haiku,
        system: [SystemPrompt] = [],
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error> {
        // In the inference call, fill the body field with a JSON object that conforms the type call you want to make [Anthropic Claude Messages API](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html ).
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
            topK: topK
        )

        let input = try InvokeModelWithResponseStreamInput(
            accept: acceptContentType,
            request: requestBody,
            contentType: requestContentType
        )

        let response = try await client.invokeModelWithResponseStream(input: input)

        guard let responseStream = response.body else {
            throw AnthropicBedrockClientError.cannotGetDataFromBedrockStreamResponse(response)
        }

        return try await AnthropicStreamingParser.parseBedrockStream(responseStream)
    }
}

extension BedrockRuntimeClientTypes.ResponseStream {
    func toString() throws -> String {
        guard case let .chunk(payload) = self else {
            throw AnthropicBedrockClientError.bedrockRuntimeClientGetsUnknownPayload(self)
        }

        guard let data = payload.bytes else {
            throw AnthropicBedrockClientError.cannotGetDataFromBedrockClientPayload(payload)
        }

        return String(decoding: data, as: UTF8.self)
    }
}
