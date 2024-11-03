//
//  BatchResultResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

import XCTest
@testable import AnthropicSwiftSDK

final class BatchResultResponseTests: XCTestCase {
    func testDecodeBatchResultResponseSucceeded() throws {
        let json = """
        {"custom_id":"request_123","result":{"type":"succeeded","message":{"id":"msg_123456","type":"message","role":"assistant","model":"claude-3-5-sonnet-20241022","content":[{"type":"text","text":"Hello again! It's nice to see you. How can I assist you today? Is there anything specific you'd like to chat about or any questions you have?"}],"stop_reason":"end_turn","stop_sequence":null,"usage":{"input_tokens":11,"output_tokens":36}}}}
        """
        
        let jsonData = json.data(using: .utf8)!
        let batchResultResponse = try anthropicJSONDecoder.decode(BatchResultResponse.self, from: jsonData)
        
        XCTAssertEqual(batchResultResponse.customId, "request_123")
        XCTAssertNotNil(batchResultResponse.result)
        XCTAssertNil(batchResultResponse.result?.error)
        
        XCTAssertEqual(batchResultResponse.result?.type, .succeeded)
        XCTAssertEqual(batchResultResponse.result?.message?.id, "msg_123456")
        XCTAssertEqual(batchResultResponse.result?.message?.type, .message)
        XCTAssertEqual(batchResultResponse.result?.message?.role, .assistant)
        guard case let .text(text1) = batchResultResponse.result?.message?.content.first else {
            XCTFail("batchResultResponse.result?.message.content.first is not .text")
            return
        }
        XCTAssertEqual(text1, "Hello again! It's nice to see you. How can I assist you today? Is there anything specific you'd like to chat about or any questions you have?")
        XCTAssertEqual(batchResultResponse.result?.message?.model?.stringfy, Model.claude_3_5_Sonnet.stringfy)
        XCTAssertEqual(batchResultResponse.result?.message?.stopReason, .endTurn)
        XCTAssertNil(batchResultResponse.result?.message?.stopSequence)
        XCTAssertEqual(batchResultResponse.result?.message?.usage.inputTokens, 11)
        XCTAssertEqual(batchResultResponse.result?.message?.usage.outputTokens, 36)
    }
    
    func testDecodeBatchResultResponseErrored() throws {
        let json = """
        {
            "custom_id": "request_456",
            "result": {
                "type": "errored",
                "error": {
                    "type": "invalid_request_error",
                    "message": "Invalid input: The provided text contains inappropriate content."
                }
            }
        }
        """
        
        let jsonData = json.data(using: .utf8)!        
        let batchResultResponse = try anthropicJSONDecoder.decode(BatchResultResponse.self, from: jsonData)
        
        XCTAssertEqual(batchResultResponse.customId, "request_456")
        XCTAssertNotNil(batchResultResponse.result)
        XCTAssertNotNil(batchResultResponse.result?.error)
        
        XCTAssertEqual(batchResultResponse.result?.type, .errored)
        XCTAssertNil(batchResultResponse.result?.message)
        
        XCTAssertEqual(batchResultResponse.result?.error?.type, .invalidRequestError)
        XCTAssertEqual(batchResultResponse.result?.error?.message, "Invalid input: The provided text contains inappropriate content.")
    }
    
    func testDecodeBatchResultResponseCancelled() throws {
        let json = """
        {
            "custom_id": "request_789",
            "result": {
                "type": "cancelled",
                "error": null
            }
        }
        """
        
        let jsonData = json.data(using: .utf8)!        
        let batchResultResponse = try anthropicJSONDecoder.decode(BatchResultResponse.self, from: jsonData)
        
        XCTAssertEqual(batchResultResponse.customId, "request_789")
        XCTAssertNotNil(batchResultResponse.result)
        XCTAssertNil(batchResultResponse.result?.error)
        
        XCTAssertEqual(batchResultResponse.result?.type, .cancelled)
        XCTAssertNil(batchResultResponse.result?.message)
    }
}
