//
//  MessageBatchesRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/22.
//

import XCTest
@testable import AnthropicSwiftSDK

final class MessageBatchesRequestTests: XCTestCase {
    
    func testMessageBatchesRequest() throws {
        let batchParameter1 = BatchParameter(
            messages: [Message(role: .user, content: [.text("こんにちは")])],
            model: .claude_3_Opus,
            maxTokens: 100
        )
        let batchParameter2 = BatchParameter(
            messages: [Message(role: .user, content: [.text("お元気ですか？")])],
            model: .claude_3_Sonnet,
            maxTokens: 200
        )
        
        let messageBatch1 = MessageBatch(customId: "test1", parameter: batchParameter1)
        let messageBatch2 = MessageBatch(customId: "test2", parameter: batchParameter2)
        
        let request = MessageBatchesRequest(body: .init(from: [messageBatch1, messageBatch2]))
        
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.path, RequestType.batches.basePath)
        XCTAssertNil(request.queries)
        XCTAssertNotNil(request.body)
        
        XCTAssertEqual(request.body?.requests.count, 2)
        
        XCTAssertEqual(request.body?.requests[0].customId, "test1")
        XCTAssertEqual(request.body?.requests[0].params.model.stringfy, Model.claude_3_Opus.stringfy)
        XCTAssertEqual(request.body?.requests[0].params.maxTokens, 100)
        XCTAssertEqual(request.body?.requests[0].params.messages.count, 1)
        XCTAssertEqual(request.body?.requests[0].params.messages[0].role.rawValue, "user")
        let content1 = try XCTUnwrap(request.body?.requests[0].params.messages[0].content)
        guard case let .text(text1, _) = content1[0] else {
            XCTFail("content1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "こんにちは")
        
        XCTAssertEqual(request.body?.requests[1].customId, "test2")
        XCTAssertEqual(request.body?.requests[1].params.model.stringfy, Model.claude_3_Sonnet.stringfy)
        XCTAssertEqual(request.body?.requests[1].params.maxTokens, 200)
        XCTAssertEqual(request.body?.requests[1].params.messages.count, 1)
        XCTAssertEqual(request.body?.requests[1].params.messages[0].role.rawValue, "user")
        let content2 = try XCTUnwrap(request.body?.requests[1].params.messages[0].content)
        guard case let .text(text2, _) = content2[0] else {
            XCTFail("content2[0] is not .text")
            return
        }
        XCTAssertEqual(text2, "お元気ですか？")
    }
}
