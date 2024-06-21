//
//  AnthropicSwiftSDK_Model+ExtensionTests.swift
//  
//
//  Created by 伊藤史 on 2024/04/04.
//

import XCTest
import AnthropicSwiftSDK
@testable import AnthropicSwiftSDK_VertexAI

class AnthropicSwiftSDK_Model_ExtensionTests: XCTestCase {

    func testVertexAIModelName_Claude3Sonnet() {
        // Given
        let model = AnthropicSwiftSDK.Model.claude_3_Sonnet

        // When
        let modelName = try? model.vertexAIModelName

        // Then
        XCTAssertEqual(modelName, "claude-3-sonnet@20240229", "Expected model name for claude_3_Sonnet")
    }

    func testVertexAIModelName_Claude3Haiku() {
        // Given
        let model = AnthropicSwiftSDK.Model.claude_3_Haiku

        // When
        let modelName = try? model.vertexAIModelName

        // Then
        XCTAssertEqual(modelName, "claude-3-haiku@20240307", "Expected model name for claude_3_Haiku")
    }

    func testVertexAIModelName_CustomModel() {
        // Given
        let customModelName = "custom_model_name"
        let model = AnthropicSwiftSDK.Model.custom(customModelName)

        // When
        let modelName = try? model.vertexAIModelName

        // Then
        XCTAssertEqual(modelName, customModelName, "Expected custom model name")
    }
}
