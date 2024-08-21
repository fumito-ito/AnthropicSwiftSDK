//
//  InputJSONDeltaAccumulatorTests.swift
//  
//
//  Created by 伊藤史 on 2024/09/04.
//

import XCTest
@testable import AnthropicSwiftSDK

final class InputJSONDeltaAccumulatorTests: XCTestCase {
    func testStreamAccumulation() async throws {
        let stream = AsyncThrowingStream.makeStream(of: StreamingResponse.self)
        let accumulated = try stream.stream.accumulated()
        stream.continuation.yield(
            StreamingContentBlockStartResponse(
                type: .contentBlockStart,
                index: 1,
                contentBlock: .toolUse(
                    .init(
                        id: "id",
                        name: "some_tool",
                        input: [:]
                    )
                )
            )
        )
        stream.continuation.yield(
            StreamingContentBlockDeltaResponse(
                type: .contentBlockDelta,
                index: 2,
                delta: .init(
                    type: .inputJSON,
                    text: nil,
                    partialJson: "{\"foo\""
                )
            )
        )
        stream.continuation.yield(
            StreamingContentBlockDeltaResponse(
                type: .contentBlockDelta,
                index: 3,
                delta: .init(
                    type: .inputJSON,
                    text: nil,
                    partialJson: ":\"bar\""
                )
            )
        )
        stream.continuation.yield(
            StreamingContentBlockDeltaResponse(
                type: .contentBlockDelta,
                index: 4,
                delta: .init(
                    type: .inputJSON,
                    text: nil,
                    partialJson: "}"
                )
            )
        )
        stream.continuation.yield(
            StreamingMessageDeltaResponse(
                type: .messageDelta,
                delta: .init(
                    stopReason: .toolUse,
                    stopSequence: nil
                ),
                usage: .init(inputTokens: 10, outputTokens: 100),
                toolUseContent: nil
            )
        )

        let result = try await accumulated.first { response in
            switch response {
            case let messageDelta as StreamingMessageDeltaResponse:
                return messageDelta.delta.stopReason == .toolUse
            default:
                return false
            }
        }

        let delta = try XCTUnwrap(result as? StreamingMessageDeltaResponse)
        XCTAssertEqual(delta.type, .messageDelta)
        XCTAssertEqual(delta.delta.stopReason, .toolUse)
        let toolUseContent = try XCTUnwrap(delta.toolUseContent)
        XCTAssertEqual(toolUseContent.id, "id")
        XCTAssertEqual(toolUseContent.name, "some_tool")
        XCTAssertEqual(toolUseContent.input.keys.first, "foo")
        XCTAssertEqual(toolUseContent.input.values.first as! String, "bar")

        stream.continuation.finish()
    }
}
