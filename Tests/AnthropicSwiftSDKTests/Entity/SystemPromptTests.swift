//
//  SystemPromptTests.swift
//  
//
//  Created by Fumito Ito on 2024/09/06.
//

import XCTest
@testable import AnthropicSwiftSDK

final class SystemPromptTests: XCTestCase {
    let encoder = JSONEncoder()

    func testEncodeSystemPrompt() throws {
        let systemPrompt = SystemPrompt.text("this is test text for system prompt test", nil)
        let dictionary = try XCTUnwrap(systemPrompt.toDictionary(encoder))

        XCTAssertEqual(dictionary["type"] as? String, "text")
        XCTAssertEqual(dictionary["text"] as? String, "this is test text for system prompt test")
        XCTAssertNil(dictionary.index(forKey: "cache_control"))
    }

    func testEncodeSystemPromptWithCacheControl() throws {
        let systemPrompt = SystemPrompt.text("this is test text for system prompt test with cache control", .ephemeral)
        let dictionary = try XCTUnwrap(systemPrompt.toDictionary(encoder))

        XCTAssertEqual(dictionary["type"] as? String, "text")
        XCTAssertEqual(dictionary["text"] as? String, "this is test text for system prompt test with cache control")
        let cacheControl = try XCTUnwrap(dictionary["cache_control"] as? [String: String])
        XCTAssertEqual(cacheControl["type"], "ephemeral")
    }
}

extension SystemPrompt {
    func toDictionary(_ encoder: JSONEncoder) throws -> [String: Any]? {
        let e = try encoder.encode(self)
        return try JSONSerialization.jsonObject(with: e, options: []) as? [String: Any]
    }
}
