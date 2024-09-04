//
//  ContentTests.swift
//  
//
//  Created by 伊藤史 on 2024/06/24.
//

import XCTest
@testable import AnthropicSwiftSDK

final class ContentTests: XCTestCase {
    // MARK: Encode
    let encoder = JSONEncoder()

    func testEncodeContentText() throws {
        let expect = Content.text("This is text")

        let dictionary = try XCTUnwrap(expect.toDictionary(encoder))
        XCTAssertEqual(dictionary["type"] as! String, "text")
        XCTAssertEqual(dictionary["text"] as! String, "This is text")
    }

    func testEncodeContentImage() throws {
        let expect = Content.image(
            .init(
                type: .base64,
                mediaType: .webp,
                data: "data".data(using: .utf8)!
            )
        )

        let dictionary = try XCTUnwrap(expect.toDictionary(encoder))
        XCTAssertEqual(dictionary["type"] as! String, "image")
        let source = try XCTUnwrap(dictionary["source"] as? [String: Any])
        XCTAssertEqual(source["type"] as! String, "base64")
        XCTAssertEqual(source["media_type"] as! String, "image/webp")
        XCTAssertEqual(
            source["data"] as! String,
            "data".data(using: .utf8)!.base64EncodedString()
        )
    }

    func testEncodeContentToolResult() throws {
        let expect = Content.toolResult(
            .init(
                toolUseId: "toolu_01A09q90qw90lq917835lq9",
                content: [
                    .text("15 degrees")
                ],
                isError: nil
            )
        )

        let dictionary = try XCTUnwrap(expect.toDictionary(encoder))
        XCTAssertEqual(dictionary["type"] as! String, "tool_result")
        XCTAssertEqual(dictionary["tool_use_id"] as! String, "toolu_01A09q90qw90lq917835lq9")
        let contents = try XCTUnwrap(dictionary["content"] as? [[String: String]])
        XCTAssertEqual(
            contents.first,
            [
                "type": "text",
                "text": "15 degrees"
            ]
        )
        XCTAssertNil(dictionary["is_error"])
    }

    func testEncodeContentToolResultWithImage() throws {
        let expect = Content.toolResult(
            .init(
                toolUseId: "toolu_01A09q90qw90lq917835lq9",
                content: [
                    .text("15 degrees"),
                    .image(.init(mediaType: .jpeg, data: "data".data(using: .utf8)!))
                ],
                isError: nil
            )
        )

        let dictionary = try XCTUnwrap(expect.toDictionary(encoder))
        XCTAssertEqual(dictionary["type"] as! String, "tool_result")
        XCTAssertEqual(dictionary["tool_use_id"] as! String, "toolu_01A09q90qw90lq917835lq9")

        let contents = try XCTUnwrap(dictionary["content"] as? [[String: Any]])
        let firstContent = try XCTUnwrap(contents.first as? [String: String])
        XCTAssertEqual(
            firstContent,
            [
                "type": "text",
                "text": "15 degrees"
            ]
        )

        XCTAssertEqual(contents[1]["type"] as! String, "image")
        let secondContentSource = try XCTUnwrap(contents[1]["source"] as? [String: String])
        XCTAssertEqual(secondContentSource["type"], "base64")
        XCTAssertEqual(secondContentSource["media_type"], "image/jpeg")
        XCTAssertEqual(secondContentSource["data"], "data".data(using: .utf8)?.base64EncodedString())

        XCTAssertNil(dictionary["is_error"])
    }

    func testEncodeContentToolResultWithError() throws {
        let expect = Content.toolResult(
            .init(
                toolUseId: "toolu_01A09q90qw90lq917835lq9",
                content: [
                    .text("ConnectionError: the weather service API is not available (HTTP 500)")
                ],
                isError: true
            )
        )

        let dictionary = try XCTUnwrap(expect.toDictionary(encoder))
        XCTAssertEqual(dictionary["type"] as! String, "tool_result")
        XCTAssertEqual(dictionary["tool_use_id"] as! String, "toolu_01A09q90qw90lq917835lq9")
        let contents = try XCTUnwrap(dictionary["content"] as? [[String: String]])
        XCTAssertEqual(
            contents.first,
            [
                "type": "text",
                "text": "ConnectionError: the weather service API is not available (HTTP 500)"
            ]
        )
        XCTAssertTrue(dictionary["is_error"] as! Bool)
    }


    // MARK: Decode

    let decoder = JSONDecoder()

    enum TestCase {
        case text
        case image
        case toolUse

        var jsonString: String {
            switch self {
            case .text:
                """
                {
                    "type": "text",
                    "text": "What's the Greek name for Sun? (A) Sol (B) Helios (C) Sun"
                }
                """
            case .image:
                """
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/jpeg",
                        "data": "/9j/4AAQSkZJRg"
                    }
                }
                """
            case .toolUse:
                """
                {
                    "type": "tool_use",
                    "id": "toolu_01A09q90qw90lq917835lq9",
                    "name": "get_weather",
                    "input": {"location": "San Francisco, CA"}
                }
                """
            }
        }
    }

    func testDecodeContentText() throws {
        let expect = try decoder.decode(
            Content.self,
            from: TestCase.text.jsonString.data(using: .utf8)!
        )

        guard case let .text(text) = expect else {
            XCTFail("Failed to decode text")
            return
        }

        XCTAssertEqual(text, "What's the Greek name for Sun? (A) Sol (B) Helios (C) Sun")
    }

    func testDecodeContentImage() throws {
        let expect = try decoder.decode(
            Content.self,
            from: TestCase.image.jsonString.data(using: .utf8)!
        )

        guard case let .image(imageContent) = expect else {
            XCTFail("Failed to decode image")
            return
        }

        XCTAssertEqual(imageContent.type, .base64)
        XCTAssertEqual(imageContent.mediaType, .jpeg)
        XCTAssertEqual(imageContent.data, "/9j/4AAQSkZJRg".data(using: .utf8)!)
    }

    func testDecodeContentToolUse() throws {
        let expect = try decoder.decode(
            Content.self,
            from: TestCase.toolUse.jsonString.data(using: .utf8)!
        )

        guard case let .toolUse(toolUseContent) = expect else {
            XCTFail("Failed to decode tool use")
            return
        }

        XCTAssertEqual(toolUseContent.id, "toolu_01A09q90qw90lq917835lq9")
        XCTAssertEqual(toolUseContent.name, "get_weather")
        XCTAssertEqual(toolUseContent.input["location"] as! String, "San Francisco, CA")
    }
}

extension Content {
    func toDictionary(_ encoder: JSONEncoder) throws -> [String: Any]? {
        let e = try encoder.encode(self)
        return try JSONSerialization.jsonObject(with: e, options: []) as? [String: Any]
    }
}
