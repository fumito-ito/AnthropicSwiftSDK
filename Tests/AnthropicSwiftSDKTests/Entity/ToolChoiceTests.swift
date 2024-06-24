//
//  ToolChoiceTests.swift
//  
//
//  Created by 伊藤史 on 2024/06/19.
//

import XCTest
@testable import AnthropicSwiftSDK

final class ToolChoiceTests: XCTestCase {
    func testEncodeToolChoiceAuto() throws {
        let encoded = try anthropicJSONEncoder.encode(ToolChoice.auto)
        let json = try JSONSerialization.jsonObject(with: encoded, options: []) as! [String: Any]

        XCTAssertEqual(json["type"] as! String, "auto")
        XCTAssertNil(json["name"])
    }

    func testEncodeToolChoiceAny() throws {
        let encoded = try anthropicJSONEncoder.encode(ToolChoice.any)
        let json = try JSONSerialization.jsonObject(with: encoded, options: []) as! [String: Any]

        XCTAssertEqual(json["type"] as! String, "any")
        XCTAssertNil(json["name"])
    }

    func testEncodeToolChoiceTool() throws {
        let encoded = try anthropicJSONEncoder.encode(ToolChoice.tool("get_weather"))
        let json = try JSONSerialization.jsonObject(with: encoded, options: []) as! [String: Any]

        XCTAssertEqual(json["type"] as! String, "tool")
        XCTAssertEqual(json["name"] as! String, "get_weather")
    }
}
