//
//  CancelMessageBatchRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/23.
//

import XCTest
@testable import AnthropicSwiftSDK

final class CancelMessageBatchRequestTests: XCTestCase {

    func testCancelMessageBatchRequest() {
        let testBatchId = "test_batch_123"

        let request = CancelMessageBatchRequest(batchId: testBatchId)

        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.path, "\(RequestType.batches.basePath)/\(testBatchId)/cancel")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
        XCTAssertEqual(request.batchId, testBatchId)
    }
}
