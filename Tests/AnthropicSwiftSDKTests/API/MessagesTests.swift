//
//  MessagesTests.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class MessagesTests: XCTestCase {
    var session = URLSession.shared

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]

        session = URLSession(configuration: configuration)
    }

    func testMessagesUsesProvidedAPIKey() async throws {
        let messages = Messages(apiKey: "This-is-test-API-key", session: session)
        let expectation = XCTestExpectation(description: "Messages uses provided api key in request header.")

        HTTPMock.inspectType = .requestHeader({ headers in
            XCTAssertEqual(headers!["x-api-key"], "This-is-test-API-key")
            expectation.fulfill()
        }, """
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
        """)

        let message = Message(role: .user, content: [.text("This is test text")])
        let _ = try await messages.createMessage([message], maxTokens: 1024)

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testCreateMessage() async throws {
        let messages = Messages(apiKey: "", session: session)
        HTTPMock.inspectType = .response("""
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
        """)

        let message = Message(role: .user, content: [.text("This is test text")])
        let response = try await messages.createMessage([message], maxTokens: 1024)

        XCTAssertEqual(response.id, "msg_01XFDUDYJgAACzvnptvVoYEL")
        XCTAssertEqual(response.type, .message)
        XCTAssertEqual(response.role, .assistant)
        XCTAssertEqual(response.content.first?.contentType, .text)
        if case let .text(text, _) = response.content.first {
            XCTAssertEqual(text, "Hello!")
        } else {
            XCTFail("Wrong type content is received.")
        }
        XCTAssertEqual(response.model?.stringfy, "claude-2.1")
        XCTAssertEqual(response.stopReason, .endTurn)
        XCTAssertNil(response.stopSequence)
        XCTAssertEqual(response.usage.inputTokens, 12)
        XCTAssertEqual(response.usage.outputTokens, 6)
    }

    func testStreamMessage() async throws {
        let messages = Messages(apiKey: "", session: session)
        HTTPMock.inspectType = .response("""
        event: message_start
        data: {"type": "message_start", "message": {"id": "msg_1nZdL29xx5MUA1yADyHTEsnR8uuvGzszyY", "type": "message", "role": "assistant", "content": [], "model": "claude-3-opus-20240229", "stop_reason": null, "stop_sequence": null, "usage": {"input_tokens": 25, "output_tokens": 1}}}

        """)

        let message = Message(role: .user, content: [.text("This is test text")])
        let stream = try await messages.streamMessage([message], maxTokens: 1024)

        for try await chunk in stream {
            let response = try XCTUnwrap(chunk as? StreamingMessageStartResponse)

            XCTAssertEqual(response.type, .messageStart)
            XCTAssertEqual(response.message.id, "msg_1nZdL29xx5MUA1yADyHTEsnR8uuvGzszyY")
            XCTAssertEqual(response.message.type, .message)
            XCTAssertEqual(response.message.role, .assistant)
            XCTAssertTrue(response.message.content.isEmpty)
            XCTAssertEqual(response.message.model?.stringfy, Model.claude_3_Opus.stringfy)
            XCTAssertNil(response.message.stopReason)
            XCTAssertNil(response.message.stopSequence)
            XCTAssertEqual(response.message.usage.inputTokens, 25)
            XCTAssertEqual(response.message.usage.outputTokens, 1)
        }
    }
    
    func testValidate_Success() {
        let messages: [Message] = [
            .init(role: .user, content: [.text("Valid message")]),
            .init(role: .user, content: [.text("Another valid message")])
        ]
        let messagesHandler = Messages(apiKey: "", session: .shared)

        XCTAssertNoThrow(try messagesHandler.validate(.claude_3_Opus, for: messages))
    }

    func testValidate_UnsupportedMessageContentContained() {
        let messages: [Message] = [
            .init(role: .user, content: [.text("Valid text message")]),
            .init(role: .user, content: [.image(.init(type: .base64, mediaType: .png, data: Data()))]) // Unsupported image
        ]
        let messagesHandler = Messages(apiKey: "", session: .shared)

        // Act & Assert
        XCTAssertThrowsError(try messagesHandler.validate(.claude_3_5_Haiku, for: messages)) { error in
            guard let clientError = error as? ClientError else {
                XCTFail("Expected ClientError but got \(error)")
                return
            }
            switch clientError {
            case .unsupportedMessageContentContained(let invalidModel, let invalidMessages):
                XCTAssertEqual(invalidModel.stringfy, Model.claude_3_5_Haiku.stringfy)
                XCTAssertEqual(invalidMessages.count, 1)
                XCTAssertEqual(invalidMessages.first?.content.first?.contentType, .image)
            default:
                XCTFail("Unexpected ClientError: \(clientError)")
            }
        }
    }

    func testValidate_AllUnsupportedMessages() {
        let messages: [Message] = [
            .init(role: .user, content: [.image(.init(type: .base64, mediaType: .png, data: Data()))]), // Unsupported image
            .init(role: .user, content: [.image(.init(type: .base64, mediaType: .png, data: Data()))])  // Unsupported image
        ]
        let messagesHandler = Messages(apiKey: "", session: .shared)

        // Act & Assert
        XCTAssertThrowsError(try messagesHandler.validate(.claude_3_5_Haiku, for: messages)) { error in
            guard let clientError = error as? ClientError else {
                XCTFail("Expected ClientError but got \(error)")
                return
            }
            switch clientError {
            case .unsupportedMessageContentContained(let invalidModel, let invalidMessages):
                XCTAssertEqual(invalidModel.stringfy, Model.claude_3_5_Haiku.stringfy)
                XCTAssertEqual(invalidMessages.count, 2)
                XCTAssertTrue(invalidMessages.allSatisfy { $0.content.first?.contentType == .image })
            default:
                XCTFail("Unexpected ClientError: \(clientError)")
            }
        }
    }
}
