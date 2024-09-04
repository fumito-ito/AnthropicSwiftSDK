//
//  AnthropicBedrockMessagesResponseParserTests.swift
//  
//
//  Created by 伊藤史 on 2024/07/03.
//

import XCTest
@testable import AnthropicSwiftSDK
import AWSBedrockRuntime
@testable import AnthropicSwiftSDK_Bedrock

final class AnthropicBedrockMessagesResponseParserTests: XCTestCase {
    func testParseMessageStartData() throws {
        let data = """
        {"type": "message_start", "message": {"id": "msg_1nZdL29xx5MUA1yADyHTEsnR8uuvGzszyY", "type": "message", "role": "assistant", "content": [], "model": "claude-3-opus-20240229", "stop_reason": null, "stop_sequence": null, "usage": {"input_tokens": 25, "output_tokens": 1}}}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingMessageStartResponse

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

    func testParseMessageDeltaData() throws {
        let data = """
        {"type": "message_delta", "delta": {"stop_reason": "end_turn", "stop_sequence":null}, "usage":{"output_tokens": 15}}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingMessageDeltaResponse

        XCTAssertEqual(result.type, .messageDelta)
        XCTAssertEqual(result.delta.stopReason, .endTurn)
        XCTAssertNil(result.delta.stopSequence)
        XCTAssertEqual(result.usage.outputTokens, 15)
        XCTAssertNil(result.usage.inputTokens)
    }

    func testParseMessageStopData() throws {
        let data = """
        {"type": "message_stop"}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingMessageStopResponse

        XCTAssertEqual(result.type, .messageStop)
    }

    func testParseContentBlockStartData() throws {
        let data = """
        {"type": "content_block_start", "index":0, "content_block": {"type": "text", "text": ""}}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingContentBlockStartResponse

        XCTAssertEqual(result.type, .contentBlockStart)
        XCTAssertEqual(result.index, 0)
        if case .text(let text) = result.contentBlock {
            XCTAssertEqual(text, "")
        } else {
            XCTFail()
        }
    }

    func testParseContentBlockStartToolUseData() throws {
        let data = """
        {"type":"content_block_start","index":0,"content_block":{"type":"tool_use","id":"toolu_01T1x1fJ34qAmk2tNTrN7Up6","name":"get_weather","input":{"foo":"bar","hoge":1}}}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingContentBlockStartResponse

        XCTAssertEqual(result.type, .contentBlockStart)
        XCTAssertEqual(result.index, 0)
        if case .toolUse(let toolUseContent) = result.contentBlock {
            XCTAssertEqual(toolUseContent.id, "toolu_01T1x1fJ34qAmk2tNTrN7Up6")
            XCTAssertEqual(toolUseContent.name, "get_weather")
            XCTAssertEqual(toolUseContent.input["foo"] as! String, "bar")
            XCTAssertEqual(toolUseContent.input["hoge"] as! Int, 1)
        } else {
            XCTFail()
        }
    }

    func testParseContentBlockDeltaData() throws {
        let data = """
        {"type": "content_block_delta", "index": 0, "delta": {"type": "text_delta", "text": "Hello"}}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingContentBlockDeltaResponse

        XCTAssertEqual(result.type, .contentBlockDelta)
        XCTAssertEqual(result.index, 0)
        XCTAssertEqual(result.delta.type, .text)
        XCTAssertEqual(result.delta.text, "Hello")
    }

    func testParseContentBlockStopData() throws {
        let data = """
        {"type": "content_block_stop", "index": 0}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingContentBlockStopResponse

        XCTAssertEqual(result.type, .contentBlockStop)
        XCTAssertEqual(result.index, 0)
    }

    func testParsePingData() throws {
        let data = """
        {"type": "ping"}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingPingResponse

        XCTAssertEqual(result.type, .ping)
    }

    func testParserErrorData() throws {
        let data = """
        {"type": "error", "error": {"type": "overloaded_error", "message": "Overloaded"}}
        """
        let response = BedrockRuntimeClientTypes.ResponseStream.chunk(.init(bytes: data.data(using: .utf8)))
        let result = try AnthropicStreamingParser.parse(responseStream: response) as! StreamingErrorResponse

        XCTAssertEqual(result.type, .error)
        XCTAssertEqual(result.error.type, .overloadedError)
        XCTAssertEqual(result.error.message, "Overloaded")
    }
}
