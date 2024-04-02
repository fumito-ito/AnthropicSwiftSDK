//
//  StreamingDataLineParserTests.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
@testable import AnthropicSwiftSDK

/// all example data lines are from https://docs.anthropic.com/claude/reference/messages-streaming
final class StreamingDataLineParserTests: XCTestCase {
    func testParseMessageStartDataLine() throws {
        let line = """
        data: {"type": "message_start", "message": {"id": "msg_1nZdL29xx5MUA1yADyHTEsnR8uuvGzszyY", "type": "message", "role": "assistant", "content": [], "model": "claude-3-opus-20240229", "stop_reason": null, "stop_sequence": null, "usage": {"input_tokens": 25, "output_tokens": 1}}}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingMessageStartResponse

        XCTAssertEqual(result.type, .messageStart)
        XCTAssertEqual(result.message.id, "msg_1nZdL29xx5MUA1yADyHTEsnR8uuvGzszyY")
        XCTAssertEqual(result.message.type, .message)
        XCTAssertEqual(result.message.role, .assistant)
        XCTAssert(result.message.content.isEmpty)
        XCTAssertEqual(result.message.model?.stringfy, "claude-3-opus-20240229")
        XCTAssertNil(result.message.stopReason)
        XCTAssertNil(result.message.stopSequence)
        XCTAssertEqual(result.message.usage.inputTokens, 25)
        XCTAssertEqual(result.message.usage.outputTokens, 1)
    }

    func testParseMessageDeltaDataLine() throws {
        let line = """
        data: {"type": "message_delta", "delta": {"stop_reason": "end_turn", "stop_sequence":null}, "usage":{"output_tokens": 15}}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingMessageDeltaResponse

        XCTAssertEqual(result.type, .messageDelta)
        XCTAssertEqual(result.delta.stopReason, .endTurn)
        XCTAssertNil(result.delta.stopSequence)
        XCTAssertEqual(result.usage.outputTokens, 15)
        XCTAssertNil(result.usage.inputTokens)
    }

    func testParseMessageStopDataLine() throws {
        let line = """
        data: {"type": "message_stop"}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingMessageStopResponse

        XCTAssertEqual(result.type, .messageStop)
    }

    func testParseContentBlockStartDataLine() throws {
        let line = """
        data: {"type": "content_block_start", "index":0, "content_block": {"type": "text", "text": ""}}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingContentBlockStartResponse

        XCTAssertEqual(result.type, .contentBlockStart)
        XCTAssertEqual(result.index, 0)
        XCTAssertEqual(result.contentBlock.type, "text")
        XCTAssertEqual(result.contentBlock.text, "")
    }

    func testParseContentBlockDeltaDataLine() throws {
        let line = """
        data: {"type": "content_block_delta", "index": 0, "delta": {"type": "text_delta", "text": "Hello"}}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingContentBlockDeltaResponse

        XCTAssertEqual(result.type, .contentBlockDelta)
        XCTAssertEqual(result.index, 0)
        XCTAssertEqual(result.delta.type, "text_delta")
        XCTAssertEqual(result.delta.text, "Hello")
    }

    func testParseContentBlockStopDataLine() throws {
        let line = """
        data: {"type": "content_block_stop", "index": 0}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingContentBlockStopResponse

        XCTAssertEqual(result.type, .contentBlockStop)
        XCTAssertEqual(result.index, 0)
    }

    func testParsePingDataLine() throws {
        let line = """
        data: {"type": "ping"}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingPingResponse

        XCTAssertEqual(result.type, .ping)
    }

    func testParserErrorDataLine() throws {
        let line = """
        data: {"type": "error", "error": {"type": "overloaded_error", "message": "Overloaded"}}
        """
        let result = try StreamingDataLineParser.parse(dataLine: line) as StreamingErrorResponse

        XCTAssertEqual(result.type, .error)
        XCTAssertEqual(result.error.type, .overloadedError)
        XCTAssertEqual(result.error.message, "Overloaded")
    }
}
