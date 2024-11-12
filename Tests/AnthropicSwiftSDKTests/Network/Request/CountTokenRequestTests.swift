//
//  CountTokenRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/13.
//

import XCTest
@testable import AnthropicSwiftSDK

final class CountTokenRequestTests: XCTestCase {
    func testEncoding() throws {
        // Prepare test data
        let message = Message(role: .user, content: [.text("Hello")])
        let systemPrompt = SystemPrompt.text("You are a helpful assistant", nil)

        let sut = CountTokenRequestBody(
            model: .claude_3_Opus,
            messages: [message],
            system: [systemPrompt],
            maxTokens: 1000,
            metaData: .init(userId: "test-user"),
            stopSequences: ["STOP"],
            stream: true,
            temperature: 0.7,
            topP: 0.9,
            topK: 10,
            tools: nil,
            toolChoice: .auto
        )

        // Encode to JSON
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(sut)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        // Verify basic properties
        XCTAssertEqual(json["model"] as? String, "claude-3-opus-20240229")
        XCTAssertEqual((json["messages"] as? [[String: Any]])?.count, 1)
        XCTAssertEqual((json["system"] as? [[String: Any]])?.count, 1)
        XCTAssertEqual(json["max_tokens"] as? Int, 1000)
        XCTAssertNotNil(json["meta_data"])
        XCTAssertEqual((json["stop_sequences"] as? [String]), ["STOP"])
        XCTAssertEqual(json["stream"] as? Bool, true)
        XCTAssertEqual(json["temperature"] as? Double, 0.7)
        XCTAssertEqual(json["top_p"] as? Double, 0.9)
        XCTAssertEqual(json["top_k"] as? Int, 10)
        XCTAssertNil(json["tools"]) // Verify tools is nil
        XCTAssertNil(json["tool_choice"])
    }

    func testEncodingWithMinimalParameters() throws {
        // Test with only required parameters
        let message = Message(role: .user, content: [.text("Hello")])
        let sut = CountTokenRequestBody(
            messages: [message],
            maxTokens: 1000
        )

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(sut)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        // Verify minimal configuration
        XCTAssertEqual(json["model"] as? String, "claude-3-opus-20240229")
        XCTAssertEqual((json["messages"] as? [[String: Any]])?.count, 1)
        XCTAssertEqual(json["max_tokens"] as? Int, 1000)
        XCTAssertNil(json["tool_choice"]) // Verify tool_choice is nil when tools are not specified
    }
}
