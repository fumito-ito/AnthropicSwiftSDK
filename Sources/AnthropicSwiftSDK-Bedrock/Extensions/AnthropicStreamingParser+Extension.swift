//
//  AnthropicStreamingParser+Extension.swift
//
//
//  Created by 伊藤史 on 2024/07/02.
//

import Foundation
import AnthropicSwiftSDK
import AWSBedrockRuntime

extension AnthropicStreamingParser {
    // swiftlint:disable:next cyclomatic_complexity
    static func parse(responseStream element: BedrockRuntimeClientTypes.ResponseStream) throws -> StreamingResponse {
        switch element {
        case .chunk(let payload):
            guard let data = payload.bytes else {
                throw AnthropicBedrockClientError.cannotGetDataFromBedrockClientPayload(payload)
            }

            let responseType = try anthropicJSONDecoder.decode(
                StreamingBaseResponse.self,
                from: data
            ).type

            switch responseType {
            case .messageStart:
                return try anthropicJSONDecoder.decode(StreamingMessageStartResponse.self, from: data)
            case .contentBlockStart:
                return try anthropicJSONDecoder.decode(StreamingContentBlockStartResponse.self, from: data)
            case .contentBlockDelta:
                return try anthropicJSONDecoder.decode(StreamingContentBlockDeltaResponse.self, from: data)
            case .contentBlockStop:
                return try anthropicJSONDecoder.decode(StreamingContentBlockStopResponse.self, from: data)
            case .messageDelta:
                return try anthropicJSONDecoder.decode(StreamingMessageDeltaResponse.self, from: data)
            case .messageStop:
                return try anthropicJSONDecoder.decode(StreamingMessageStopResponse.self, from: data)
            case .ping:
                return try anthropicJSONDecoder.decode(StreamingPingResponse.self, from: data)
            case .error:
                return try anthropicJSONDecoder.decode(StreamingErrorResponse.self, from: data)
            }
        case .sdkUnknown(let error):
            throw AnthropicBedrockClientError.bedrockRuntimeClientGetsErrorInStream(error)
        }
    }

    static func parseBedrockStream<T: AsyncSequence>(_ stream: T) async throws -> AsyncThrowingStream<StreamingResponse, Error> where T.Element == BedrockRuntimeClientTypes.ResponseStream {
        return AsyncThrowingStream.init { continuation in
            let task = Task {
                for try await element in stream {
                    do {
                        continuation.yield(try parse(responseStream: element))
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }

            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }
}

struct StreamingBaseResponse: StreamingResponse {
    var type: StreamingEvent
}
