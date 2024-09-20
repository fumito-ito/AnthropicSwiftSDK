//
//  StreamingMessageDeltaResponseTests.swift
//  
//
//  Created by 伊藤史 on 2024/09/03.
//

import XCTest
import FunctionCalling
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

    func testToolContainerIsExecutedByResponse() async throws {
        struct MockToolContiner: ToolContainer {
            var allToolsJSONString: String {
                ""
            }
            
            var service: FunctionCallingService {
                .claude
            }
            
            func execute(methodName name: String, parameters: [String : Any]) async -> String {
                return "executed,\(name),\(parameters.keys.first ?? "")"
            }
            
            var allTools: [Tool]? {
                nil
            }
        }

        let responseWithContent = StreamingMessageDeltaResponse(
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
                input: ["input1":1]
            )
        )

        let result = await responseWithContent.getToolResultContent(from: MockToolContiner())

        XCTAssertEqual(result?.contentType, .toolResult)
        if case let .toolResult(toolResult) = result {
            XCTAssertEqual(toolResult.toolUseId, "1")
            XCTAssertTrue(toolResult.isError == false)
            if case let .text(text) = toolResult.content.first {
                let arguments = text.split(separator: ",")
                XCTAssertEqual(arguments.count, 3)
                XCTAssertEqual(arguments[0], "executed")
                XCTAssertEqual(arguments[1], "some_tool")
                XCTAssertEqual(arguments[2], "input1")
            } else {
                XCTFail("Content should be string")
            }
        } else {
            XCTFail("Content should be toolResult")
        }
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
