//
//  ModelTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/27.
//

import XCTest
@testable import AnthropicSwiftSDK

final class ModelTests: XCTestCase {

    func testIsSupportBatches() {
        XCTAssertTrue(Model.claude_3_Opus.isSupportBatches, "claude_3_Opus should support batches.")
        XCTAssertFalse(Model.claude_3_Sonnet.isSupportBatches, "claude_3_Sonnet should not support batches.")
        XCTAssertTrue(Model.claude_3_Haiku.isSupportBatches, "claude_3_Haiku should support batches.")
        XCTAssertTrue(Model.claude_3_5_Sonnet.isSupportBatches, "claude_3_5_Sonnet should support batches.")
        XCTAssertTrue(Model.claude_3_5_Haiku.isSupportBatches, "claude_3_5_Haiku should support batches.")
        XCTAssertTrue(Model.custom("custom-model").isSupportBatches, "Custom models should support batches.")
    }

    func testIsSupportVision() {
        XCTAssertTrue(Model.claude_3_Opus.isSupportVision, "claude_3_Opus should support vision.")
        XCTAssertTrue(Model.claude_3_Sonnet.isSupportVision, "claude_3_Sonnet should support vision.")
        XCTAssertTrue(Model.claude_3_Haiku.isSupportVision, "claude_3_Haiku should support vision.")
        XCTAssertTrue(Model.claude_3_5_Sonnet.isSupportVision, "claude_3_5_Sonnet should support vision.")
        XCTAssertFalse(Model.claude_3_5_Haiku.isSupportVision, "claude_3_5_Haiku should not support vision.")
        XCTAssertTrue(Model.custom("custom-model").isSupportVision, "Custom models should support vision.")
    }

    func testIsValid() {
        
        let textMessage = Message(role: .user, content: [.text("")])
        let imageMessage = Message(role: .user, content: [.image(.init(type: .base64, mediaType: .gif, data: Data()))])
        let documentMessage = Message(role: .user, content: [.document(.init(type: .base64, mediaType: .pdf, data: Data()))])
        
        // Models that support vision
        XCTAssertTrue(Model.claude_3_Opus.isValid(for: textMessage), "claude_3_Opus should validate text messages.")
        XCTAssertTrue(Model.claude_3_Opus.isValid(for: imageMessage), "claude_3_Opus should validate image messages.")
        XCTAssertTrue(Model.claude_3_Opus.isValid(for: documentMessage), "claude_3_Opus should validate document messages.")

        XCTAssertTrue(Model.claude_3_Sonnet.isValid(for: textMessage), "claude_3_Opus should validate text messages.")
        XCTAssertTrue(Model.claude_3_Sonnet.isValid(for: imageMessage), "claude_3_Opus should validate image messages.")
        XCTAssertTrue(Model.claude_3_Sonnet.isValid(for: documentMessage), "claude_3_Opus should validate document messages.")

        XCTAssertTrue(Model.claude_3_Haiku.isValid(for: textMessage), "claude_3_Opus should validate text messages.")
        XCTAssertTrue(Model.claude_3_Haiku.isValid(for: imageMessage), "claude_3_Opus should validate image messages.")
        XCTAssertTrue(Model.claude_3_Haiku.isValid(for: documentMessage), "claude_3_Opus should validate document messages.")

        XCTAssertTrue(Model.claude_3_5_Sonnet.isValid(for: textMessage), "claude_3_Opus should validate text messages.")
        XCTAssertTrue(Model.claude_3_5_Sonnet.isValid(for: imageMessage), "claude_3_Opus should validate image messages.")
        XCTAssertTrue(Model.claude_3_5_Sonnet.isValid(for: documentMessage), "claude_3_Opus should validate document messages.")

        XCTAssertTrue(Model.claude_3_5_Haiku.isValid(for: textMessage), "claude_3_Opus should validate text messages.")
        XCTAssertFalse(Model.claude_3_5_Haiku.isValid(for: imageMessage), "claude_3_Opus should validate image messages.")
        XCTAssertTrue(Model.claude_3_5_Haiku.isValid(for: documentMessage), "claude_3_Opus should validate document messages.")

        XCTAssertTrue(Model.custom("custom-model").isValid(for: textMessage), "claude_3_Opus should validate text messages.")
        XCTAssertTrue(Model.custom("custom-model").isValid(for: imageMessage), "claude_3_Opus should validate image messages.")
        XCTAssertTrue(Model.custom("custom-model").isValid(for: documentMessage), "claude_3_Opus should validate document messages.")
    }
}
