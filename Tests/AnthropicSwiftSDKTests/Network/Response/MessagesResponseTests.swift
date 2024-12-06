//
//  MessagesResponseTests.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
@testable import AnthropicSwiftSDK

/// all example json objects are from https://docs.anthropic.com/claude/reference/messages-examples
final class MessagesResponseTests: XCTestCase {
    func testParseBasicResponse() {
        let json = """
        {
          "id": "msg_01XFDUDYJgAACzvnptvVoYEL",
          "type": "message",
          "role": "assistant",
          "content": [
            {
              "type": "text",
              "text": "Hello!"
            }
          ],
          "model": "claude-2.1",
          "stop_reason": "end_turn",
          "stop_sequence": null,
          "usage": {
            "input_tokens": 12,
            "output_tokens": 6
          }
        }
        """
        XCTAssertNoThrow(try anthropicJSONDecoder.decode(MessagesResponse.self, from: json.data(using: .utf8)!))
    }

    func testParseMultipleConversationalTurnsResponse() {
        let json = """
        {
            "id": "msg_018gCsTGsXkYJVqYPxTgDHBU",
            "type": "message",
            "role": "assistant",
            "content": [
                {
                    "type": "text",
                    "text": "Sure, I'd be happy to provide..."
                }
            ],
            "stop_reason": "end_turn",
            "stop_sequence": null,
            "usage": {
              "input_tokens": 30,
              "output_tokens": 309
            }
        }
        """
        XCTAssertNoThrow(try anthropicJSONDecoder.decode(MessagesResponse.self, from: json.data(using: .utf8)!))
    }

    func testPuttingWordsInClaudesMouthResponse() {
        let json = """
        {
          "id": "msg_01Q8Faay6S7QPTvEUUQARt7h",
          "type": "message",
          "role": "assistant",
          "content": [
            {
              "type": "text",
              "text": "C"
            }
          ],
          "model": "claude-2.1-basil",
          "stop_reason": "max_tokens",
          "stop_sequence": null,
          "usage": {
            "input_tokens": 42,
            "output_tokens": 1
          }
        }
        """
        XCTAssertNoThrow(try anthropicJSONDecoder.decode(MessagesResponse.self, from: json.data(using: .utf8)!))
    }

    func testVisionResponse() {
        let json = """
        {
          "id": "msg_01EcyWo6m4hyW8KHs2y2pei5",
          "type": "message",
          "role": "assistant",
          "content": [
            {
              "type": "text",
              "text": "This image shows an ant, specifically a close-up view of an ant. The ant is shown in detail, with its distinct head, antennae, and legs clearly visible. The image is focused on capturing the intricate details and features of the ant, likely taken with a macro lens to get an extreme close-up perspective."
            }
          ],
          "model": "claude-2.1",
          "stop_reason": "end_turn",
          "stop_sequence": null,
          "usage": {
            "input_tokens": 1551,
            "output_tokens": 71
          }
        }
        """
        XCTAssertNoThrow(try anthropicJSONDecoder.decode(MessagesResponse.self, from: json.data(using: .utf8)!))
    }
}
