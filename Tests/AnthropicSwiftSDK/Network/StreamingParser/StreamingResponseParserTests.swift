//
//  StreamingResponseParserTests.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
@testable import AnthropicSwiftSDK

final class StreamingResponseParserTests: XCTestCase {
    func testReturnEmptyIfEmptyLine() throws {
        let result = try StreamingResponseParser.parse(line: "")
        XCTAssertEqual(result, .empty)
    }

    func testReturnDataIfLineFirstCharIsD() throws {
        let result = try StreamingResponseParser.parse(line: "de")
        XCTAssertEqual(result, .data)
    }

    func testReturnEventIfLineFirstCharIsE() throws {
        let result = try StreamingResponseParser.parse(line: "ed")
        XCTAssertEqual(result, .event)
    }

    func testThrowErrorIfUnknownCharIsPassed() {
        XCTAssertThrowsError(try StreamingResponseParser.parse(line: "foobar"))
    }
}
