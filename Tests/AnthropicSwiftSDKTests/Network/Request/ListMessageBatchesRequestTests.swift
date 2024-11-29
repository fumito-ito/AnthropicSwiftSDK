//
//  ListMessageBatchesRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/23.
//

import XCTest
@testable import AnthropicSwiftSDK

final class ListObjectRequestTests: XCTestCase {

    func testListObjectRequestProperties() {
        let queries: [String: CustomStringConvertible] = [
            "before_id": "batch123",
            "after_id": "batch456",
            "limit": 10
        ]
        let request = ListObjectRequest(queries: queries, type: .batches)

        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.path, RequestType.batches.basePath)
        XCTAssertEqual(request.queries?["before_id"] as? String, "batch123")
        XCTAssertEqual(request.queries?["after_id"] as? String, "batch456")
        XCTAssertEqual(request.queries?["limit"] as? Int, 10)
        XCTAssertNil(request.body)
    }

    func testParameterRawValues() {
        XCTAssertEqual(ListObjectRequest.Parameter.beforeId.rawValue, "before_id")
        XCTAssertEqual(ListObjectRequest.Parameter.afterId.rawValue, "after_id")
        XCTAssertEqual(ListObjectRequest.Parameter.limit.rawValue, "limit")
    }
}
