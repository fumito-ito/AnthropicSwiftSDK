//
//  Messages.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

// TODO: debuglog
// TODO: できたらretryできるようにする
public struct Messages {
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }

    public func createMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Int? = nil,
        topK: Int? = nil
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
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func createMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Int? = nil,
        topK: Int? = nil,
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
            topK: topK
        )

        let (data, response) = try await client.send(requestBody: requestBody)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try AnthropicJSONDecoder.decode(MessagesResponse.self, from: data)
    }

    public func streamMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Int? = nil,
        topK: Int? = nil
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
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func streamMessage(
        _ messages: [Message],
        model: Model = .claude_3_Opus,
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Int? = nil,
        topK: Int? = nil,
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
            topK: topK
        )

        let (data, response) = try await client.stream(requestBody: requestBody)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return AsyncThrowingStream.init { continuation in
            let task = Task {
                var currentEvent: StreamingEvent? = nil
                for try await line in data.lines {
                    do {
                        let lineType = try StreamingResponseParser.parse(line: line)
                        switch lineType {
                        case .empty:
                            break
                        case .event:
                            currentEvent = try StreamingEventLineParser.parse(eventLine: line)
                        case .data:
                            guard let currentEvent = currentEvent else {
                                break
                            }

                            switch currentEvent {
                            case .ping:
                                continuation.yield(try StreamingDataLineParser.parse(dataLine: line) as StreamingPingResponse)
                            case .messageStart:
                                continuation.yield(try StreamingDataLineParser.parse(dataLine: line) as StreamingMessageStartResponse)
                            case .messageDelta:
                                continuation.yield(try StreamingDataLineParser.parse(dataLine: line) as StreamingMessageDeltaResponse)
                            case .messageStop:
                                continuation.yield(try StreamingDataLineParser.parse(dataLine: line) as StreamingMessageStopResponse)
                            case .contentBlockStart:
                                continuation.yield(try StreamingDataLineParser.parse(dataLine: line) as StreamingContentBlockStartResponse)
                            case .contentBlockDelta:
                                continuation.yield(try StreamingDataLineParser.parse(dataLine: line) as StreamingContentBlockDeltaResponse)
                            case .contentBlockStop:
                                continuation.yield(try StreamingDataLineParser.parse(dataLine: line) as StreamingContentBlockStopResponse)
                            case .error:
                                let data = try StreamingDataLineParser.parse(dataLine: line) as StreamingErrorResponse
                                continuation.finish(throwing: data.error.type)
                            }
                        }
                    } catch let error {
                        continuation.finish(throwing: error)
                    }
                }

                continuation.finish()
            }
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}
