//
//  RetrieveMessageBatchesRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/22.
//

import XCTest
@testable import AnthropicSwiftSDK

final class RetrieveMessageBatchesRequestTests: XCTestCase {
    
    func testRetrieveMessageBatchesRequest() {
        let testBatchId = "test_batch_123"
        let request = RetrieveMessageBatchesRequest(batchId: testBatchId)
        
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.path, "\(RequestType.batches.basePath)/\(testBatchId)")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
        XCTAssertEqual(request.batchId, testBatchId)
    }
}