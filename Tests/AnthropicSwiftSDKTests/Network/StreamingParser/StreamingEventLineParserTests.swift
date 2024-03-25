//
//  StreamingEventLineParserTests.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
@testable import AnthropicSwiftSDK

final class StreamingEventLineParserTests: XCTestCase {
    func testReturnCorrectEventWhenEventNamePassed() throws {
        let messageStart = try StreamingEventLineParser.parse(eventLine: "event: message_start")
        XCTAssertEqual(messageStart, .messageStart)

        let messageDelta = try StreamingEventLineParser.parse(eventLine: "event: message_delta")
        XCTAssertEqual(messageDelta, .messageDelta)

        let messageStop = try StreamingEventLineParser.parse(eventLine: "event: message_stop")
        XCTAssertEqual(messageStop, .messageStop)

        let contentBlockStart = try StreamingEventLineParser.parse(eventLine: "event: content_block_start")
        XCTAssertEqual(contentBlockStart, .contentBlockStart)

        let contentBlockDelta = try StreamingEventLineParser.parse(eventLine: "event: content_block_delta")
        XCTAssertEqual(contentBlockDelta, .contentBlockDelta)

        let contentBlockStop = try StreamingEventLineParser.parse(eventLine: "event: content_block_stop")
        XCTAssertEqual(contentBlockStop, .contentBlockStop)

        let ping = try StreamingEventLineParser.parse(eventLine: "event: ping")
        XCTAssertEqual(ping, .ping)

        let error = try StreamingEventLineParser.parse(eventLine: "event: error")
        XCTAssertEqual(error, .error)
    }

    func testThrowErrorWhenInvalidEventNamePassed() {
        XCTAssertThrowsError(try StreamingEventLineParser.parse(eventLine: "event: unknown"))
        XCTAssertThrowsError(try StreamingEventLineParser.parse(eventLine: "event: message_start_a")) // not start
    }
}
