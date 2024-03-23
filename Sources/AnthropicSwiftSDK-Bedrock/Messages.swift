//
//  Messages.swift
//
//
//  Created by 伊藤史 on 2024/03/22.
//

import Foundation
import AnthropicSwiftSDK
import AWSBedrockRuntime

public struct Messages {
    private let acceptContentType = "application/json"
    private let requestContentType = "application/json"
    private let client: BedrockRuntimeClient

    public let model: Model

    init(client: BedrockRuntimeClient, model: Model) {
        self.client = client
        self.model = model
    }

    public func createMessage(
        _ messages: [Message],
        model: Model = .claude_3_Haiku,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Int? = nil,
        topK: Int? = nil
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

    public func streamMessage(
        _ messages: [Message],
        model: Model = .claude_3_Haiku,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Int? = nil,
        topK: Int? = nil
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error> {
        // In the inference call, fill the body field with a JSON object that conforms the type call you want to make [Anthropic Claude Messages API](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-anthropic-claude-messages.html).
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

        let data = try anthropicJSONEncoder.encode(requestBody)

        let input = try InvokeModelWithResponseStreamInput(
            accept: acceptContentType,
            request: requestBody,
            contentType: requestContentType
        )

        let response = try await client.invokeModelWithResponseStream(input: input)

        guard let responseStream = response.body else {
            fatalError()
        }

        return try await AnthropicStreamingParser.parse(stream: responseStream.map { try $0.toString() })
    }
}

extension BedrockRuntimeClientTypes.ResponseStream {
    func toString() throws -> String {
        guard case let .chunk(payload) = self else {
            fatalError()
        }

        guard let data = payload.bytes,
              let line = String(data: data, encoding: .utf8) else {
            fatalError()
        }

        return line
    }
}