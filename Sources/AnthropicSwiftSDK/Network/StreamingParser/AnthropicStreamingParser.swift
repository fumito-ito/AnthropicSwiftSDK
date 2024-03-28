//
//  AnthropicStreamingParser.swift
//
//
//  Created by 伊藤史 on 2024/03/24.
//

import Foundation

public enum AnthropicStreamingParser {
    // swiftlint:disable:next cyclomatic_complexity
    public static func parse<T: AsyncSequence>(stream: T) async throws -> AsyncThrowingStream<StreamingResponse, Error> where T.Element == String {
        return AsyncThrowingStream.init { continuation in
            let task = Task {
                var currentEvent: StreamingEvent?
                for try await line in stream {
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
