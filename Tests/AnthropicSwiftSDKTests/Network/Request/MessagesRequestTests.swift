//
//  MessagesRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/22.
//

import XCTest
@testable import AnthropicSwiftSDK

final class MessagesRequestTests: XCTestCase {
    func testMessagesRequest() throws {
        let messages = [Message(role: .user, content: [.text("こんにちは")])]
        let systemPrompt: [SystemPrompt] = [.text("あなたは親切なアシスタントです。", .ephemeral)]
        
        let requestBody = MessagesRequestBody(
            model: .claude_3_Opus,
            messages: messages,
            system: systemPrompt,
            maxTokens: 100,
            metaData: MetaData(userId: "test-user"),
            stopSequences: ["END"],
            stream: false,
            temperature: 0.7,
            topP: 0.9,
            topK: 10,
            tools: nil,
            toolChoice: .auto
        )
        
        let request = MessagesRequest(body: requestBody)
        
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.path, RequestType.messages.basePath)
        XCTAssertNil(request.queries)
        
        XCTAssertEqual(request.body?.model.stringfy, Model.claude_3_Opus.stringfy)
        XCTAssertEqual(request.body?.messages.count, 1)
        XCTAssertEqual(request.body?.messages[0].role.rawValue, "user")
        let content1 = try XCTUnwrap(request.body?.messages[0].content)
        guard case let .text(text1) = content1[0] else {
            XCTFail("content1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "こんにちは")
        let system1 = try XCTUnwrap(request.body?.system)
        guard case let .text(text1, _) = system1[0] else {
            XCTFail("system1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "あなたは親切なアシスタントです。")
        XCTAssertEqual(request.body?.maxTokens, 100)
        XCTAssertEqual(request.body?.metaData?.userId, "test-user")
        XCTAssertEqual(request.body?.stopSequences, ["END"])
        XCTAssertFalse(request.body?.stream ?? true)
        XCTAssertEqual(request.body?.temperature, 0.7)
        XCTAssertEqual(request.body?.topP, 0.9)
        XCTAssertEqual(request.body?.topK, 10)
        XCTAssertNil(request.body?.tools)
        XCTAssertNil(request.body?.toolChoice)
    }
    
    func testMessagesRequestWithBatchParameter() throws {
        let messages = [Message(role: .user, content: [.text("こんにちは")])]
        let systemPrompt: [SystemPrompt] = [.text("あなたは親切なアシスタントです。", .ephemeral)]
        
        let batchParameter = BatchParameter(
            messages: messages,
            model: .claude_3_Opus,
            system: systemPrompt,
            maxTokens: 100,
            metaData: MetaData(userId: "test-user"),
            stopSequence: ["END"],
            temperature: 0.7,
            topP: 0.9,
            topK: 10,
            tools: nil,
            toolChoice: .auto
        )
        
        let requestBody = MessagesRequestBody(from: batchParameter)
        let request = MessagesRequest(body: requestBody)
        
        XCTAssertEqual(request.body?.model.stringfy, Model.claude_3_Opus.stringfy)
        XCTAssertEqual(request.body?.messages.count, 1)
        XCTAssertEqual(request.body?.messages[0].role.rawValue, "user")
        let content1 = try XCTUnwrap(request.body?.messages[0].content)
        guard case let .text(text1) = content1[0] else {
            XCTFail("content1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "こんにちは")
        let system1 = try XCTUnwrap(request.body?.system)
        guard case let .text(text1, _) = system1[0] else {
            XCTFail("system1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "あなたは親切なアシスタントです。")
        XCTAssertEqual(request.body?.maxTokens, 100)
        XCTAssertEqual(request.body?.metaData?.userId, "test-user")
        XCTAssertEqual(request.body?.stopSequences, ["END"])
        XCTAssertFalse(request.body?.stream ?? true)
        XCTAssertEqual(request.body?.temperature, 0.7)
        XCTAssertEqual(request.body?.topP, 0.9)
        XCTAssertEqual(request.body?.topK, 10)
        XCTAssertNil(request.body?.tools)
        XCTAssertNil(request.body?.toolChoice)
    }
}
