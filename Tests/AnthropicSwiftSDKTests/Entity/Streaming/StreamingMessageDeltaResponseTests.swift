//
//  StreamingMessageDeltaResponseTests.swift
//  
//
//  Created by 伊藤史 on 2024/09/03.
//

import XCTest
@testable import AnthropicSwiftSDK

final class StreamingMessageDeltaResponseTests: XCTestCase {
    func testIsToolUseReturnTrueIfDeltaContainContent() {
        let response = StreamingMessageDeltaResponse(
            type: .messageDelta,
            delta: .init(
                stopReason: .toolUse,
                stopSequence: nil),
            usage: .init(
                inputTokens: 1,
                outputTokens: 1
            ),
            toolUseContent: .init(
                id: "1",
                name: "some_tool",
                input: [:]
            )
        )

        XCTAssertTrue(response.isToolUse)
    }

    func testIsToolUseReturnFalseIfDeltaNotContainedCotnent() {
        let responseWithoutContent = StreamingMessageDeltaResponse(
            type: .messageDelta,
            delta: .init(
                stopReason: .toolUse,
                stopSequence: nil),
            usage: .init(
                inputTokens: 1,
                outputTokens: 1
            ),
            toolUseContent: nil
        )

        XCTAssertFalse(responseWithoutContent.isToolUse)

        let responseWithoutReason = StreamingMessageDeltaResponse(
            type: .messageDelta,
            delta: .init(
                stopReason: .endTurn,
                stopSequence: nil),
            usage: .init(
                inputTokens: 1,
                outputTokens: 1
            ),
            toolUseContent: .init(
                id: "1",
                name: "some_tool",
                input: [:]
            )
        )

        XCTAssertFalse(responseWithoutReason.isToolUse)
    }

    func testContentIsAddedIntoResponse() {
        let responseWithoutContent = StreamingMessageDeltaResponse(
            type: .messageDelta,
            delta: .init(
                stopReason: .toolUse,
                stopSequence: nil),
            usage: .init(
                inputTokens: 1,
                outputTokens: 1
            ),
            toolUseContent: nil
        )

        let responseWithContent = responseWithoutContent.added(
            toolUseContent: .init(
                id: "1",
                name: "some_tool",
                input: [:]
            )
        )

        XCTAssertNotNil(responseWithContent.toolUseContent)
        XCTAssertEqual(responseWithContent.toolUseContent?.id, "1")
        XCTAssertEqual(responseWithContent.toolUseContent?.name, "some_tool")
        XCTAssertTrue((responseWithContent.toolUseContent?.input.isEmpty == true))
    }
}
