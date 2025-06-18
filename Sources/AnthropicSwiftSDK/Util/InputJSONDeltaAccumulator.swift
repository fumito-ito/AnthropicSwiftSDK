//
//  InputJSONDeltaAccumulator.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/08/22.
//

import Foundation

class InputJSONDeltaAccumulator: @unchecked Sendable {
    private var partialJson: [StreamingContentBlockDeltaResponse] = []
    private var toolUseInfo: StreamingContentBlockStartResponse?
    private var accumulativeStream: AsyncThrowingStream<StreamingResponse, Error>.Continuation?

    /// Receive StreamingResponse and collect `tool_use` related information if it exists. When `message_stop` is detected, the collected `tool_use`-related information is compiled and sent together with the `StreamingMessageDeltaResponse`.
    /// - Parameter response: `StreamingResponse` to collect data
    func accumulateIfNeeded(_ response: StreamingResponse) throws {
        switch response {
        case let contentBlockStart as StreamingContentBlockStartResponse:
            if case .toolUse = contentBlockStart.contentBlock {
                toolUseInfo = contentBlockStart
            }
            accumulativeStream?.yield(response)
        case let contentBlockDelta as StreamingContentBlockDeltaResponse:
            if contentBlockDelta.delta.type == .inputJSON {
                partialJson.append(contentBlockDelta)
            }
            accumulativeStream?.yield(response)
        case let messageDelta as StreamingMessageDeltaResponse:
            if messageDelta.delta.stopReason == .toolUse {
                let toolUseContent = try aggregateToolUseContent(from: partialJson, with: toolUseInfo)
                let modifiedResponse = messageDelta.added(toolUseContent: toolUseContent)
                accumulativeStream?.yield(modifiedResponse)
            } else {
                accumulativeStream?.yield(response)
            }
        default:
            accumulativeStream?.yield(response)
        }
    }

    /// Aggregate the `input_json_delta` of the collected `tool_use` to generate a JSON String and return it as a `ToolUseContent` with other information from the `tool_use`.
    ///
    /// - Parameters:
    ///   - delta: Set of `StreamingContentBlockDeltaResponse` containing `input_json_delta`.
    ///   - toolUseInfo: `StreamingContentBlockStartResponse` containing `tool_use` id, etc.
    /// - Returns: aggregated `ToolUseContent`
    private func aggregateToolUseContent(from delta: [StreamingContentBlockDeltaResponse], with toolUseInfo: StreamingContentBlockStartResponse?) throws -> ToolUseContent {
        guard case .toolUse(let toolUse) = toolUseInfo?.contentBlock else {
            throw ClientError.cannotFindToolUseContentFromContentBlockStart(toolUseInfo?.contentBlock)
        }

        guard
            let jsonData = delta.compactMap({ $0.delta.partialJson }).joined().data(using: .utf8),
            let input = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw ClientError.failedToAggregatePartialJSONStringIntoJSONObject(delta.compactMap { $0.delta.partialJson }.joined())
        }

        return ToolUseContent(id: toolUse.id, name: toolUse.name, input: input)
    }

    /// Creates a new `AsyncThrowingStream` with a new `StreamingResponse`. This stream will aggregate `tool_use` related information.
    /// - Returns: aggregated stream
    func createAccumulativeStream() -> AsyncThrowingStream<StreamingResponse, Error> {
        AsyncThrowingStream { continuation in
            self.accumulativeStream = continuation
        }
    }

    /// Stop aggregated stream
    func finish() {
        accumulativeStream?.finish()
    }

    func finish(throwing error: Error) {
        accumulativeStream?.finish(throwing: error)
    }
}
