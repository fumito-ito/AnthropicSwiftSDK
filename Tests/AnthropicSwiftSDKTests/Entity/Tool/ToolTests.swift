//
//  ToolTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/30.
//

import XCTest
@testable import AnthropicSwiftSDK

import XCTest
@testable import AnthropicSwiftSDK

final class ToolTests: XCTestCase {
    func testBashToolEncoding() throws {
        let tool = BashTool(type: .bash20241022, name: "bash")
        let encoded = try anthropicJSONEncoder.encode(tool)
        let decoded = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]

        XCTAssertEqual(decoded?["type"] as? String, "bash_20241022")
        XCTAssertEqual(decoded?["name"] as? String, "bash")
    }

    func testComputerToolEncoding() throws {
        let tool = ComputerTool(
            type: .computer20241022,
            name: "computer",
            displayWidthPx: 1024,
            displayHeightPx: 768,
            displayNumber: 1
        )
        let encoded = try anthropicJSONEncoder.encode(tool)
        let decoded = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]

        XCTAssertEqual(decoded?["type"] as? String, "computer_20241022")
        XCTAssertEqual(decoded?["name"] as? String, "computer")
        XCTAssertEqual(decoded?["display_width_px"] as? Int, 1024)
        XCTAssertEqual(decoded?["display_height_px"] as? Int, 768)
        XCTAssertEqual(decoded?["display_number"] as? Int, 1)
    }

    func testTextEditorToolEncoding() throws {
        let tool = TextEditorTool(type: .textEditor20241022, name: "str_replace_editor")
        let encoded = try anthropicJSONEncoder.encode(tool)
        let decoded = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]

        XCTAssertEqual(decoded?["type"] as? String, "textEditor_20241022")
        XCTAssertEqual(decoded?["name"] as? String, "str_replace_editor")
    }

    func testFunctionToolEncoding() throws {
        let locationSchema = InputSchema(
            type: .string,
            format: nil,
            description: "The city and state, e.g. San Francisco, CA",
            nullable: nil,
            enumValues: nil,
            items: nil,
            properties: nil,
            requiredProperties: nil
        )

        let unitSchema = InputSchema(
            type: .string,
            format: nil,
            description: "The unit of temperature, either 'celsius' or 'fahrenheit'",
            nullable: nil,
            enumValues: ["celsius", "fahrenheit"],
            items: nil,
            properties: nil,
            requiredProperties: nil
        )

        let rootSchema = InputSchema(
            type: .object,
            format: nil,
            description: "",
            nullable: nil,
            enumValues: nil,
            items: nil,
            properties: [
                "location": locationSchema,
                "unit": unitSchema
            ],
            requiredProperties: ["location"]
        )

        let tool = FunctionTool(
            name: "get_weather",
            description: "Get the current weather in a given location",
            inputSchema: rootSchema
        )

        let encoded = try anthropicJSONEncoder.encode(tool)
        let decoded = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]

        XCTAssertEqual(decoded?["name"] as? String, "get_weather")
        XCTAssertEqual(decoded?["description"] as? String, "Get the current weather in a given location")

        let inputSchema = decoded?["input_schema"] as? [String: Any]
        XCTAssertEqual(inputSchema?["type"] as? String, "object")
        XCTAssertEqual(inputSchema?["description"] as? String, "")

        let properties = inputSchema?["properties"] as? [String: Any]
        let location = properties?["location"] as? [String: Any]
        XCTAssertEqual(location?["type"] as? String, "string")
        XCTAssertEqual(location?["description"] as? String, "The city and state, e.g. San Francisco, CA")

        let unit = properties?["unit"] as? [String: Any]
        XCTAssertEqual(unit?["type"] as? String, "string")
        XCTAssertEqual(unit?["description"] as? String, "The unit of temperature, either 'celsius' or 'fahrenheit'")
        XCTAssertEqual(unit?["enum"] as? [String], ["celsius", "fahrenheit"])

        XCTAssertEqual(inputSchema?["required"] as? [String], ["location"])
    }

    func testDefaultToolTypes() {
        XCTAssertEqual(BashTool.BashType.bash20241022.rawValue, "bash_20241022")
        XCTAssertEqual(ComputerTool.ComputerType.computer20241022.rawValue, "computer_20241022")
        XCTAssertEqual(TextEditorTool.TextEditorType.textEditor20241022.rawValue, "textEditor_20241022")
    }
}
