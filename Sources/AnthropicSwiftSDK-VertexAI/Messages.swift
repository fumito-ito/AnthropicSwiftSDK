//
//  Messages.swift
//  
//
//  Created by 伊藤史 on 2024/03/26.
//

import Foundation
import AnthropicSwiftSDK

public struct Messages {
    let apiKey: String
    let projectId: String
    let region: SupportedRegion

    init(apiKey: String, projectId: String, region: SupportedRegion) {
        self.apiKey = apiKey
        self.projectId = projectId
        self.region = region
    }

    public func createMessage(
        _ messages: [Message],
        model: Model = .claude_3_Haiku,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil
    ) async throws -> MessagesResponse {
        let modelName = try model.vertexAIModelName
        let client = VertexAIClient(location: region, projectId: projectId, modelName: modelName, apiKey: apiKey)

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

        let (data, response) = try await client.send(requestBody: requestBody)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try anthropicJSONDecoder.decode(MessagesResponse.self, from: data)
    }

    public func streamMessage(
        _ messages: [Message],
        model: Model = .claude_3_Haiku,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error> {
        let modelName = try model.vertexAIModelName
        let client = VertexAIClient(location: region, projectId: projectId, modelName: modelName, apiKey: apiKey)

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

        let (data, response) = try await client.stream(requestBody: requestBody)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try await AnthropicStreamingParser.parse(stream: data.lines)
    }
}
