//
//  RetrieveMessageBatchResultsRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/22.
//

import XCTest
@testable import AnthropicSwiftSDK

final class RetrieveMessageBatchResultsRequestTests: XCTestCase {
    
    func testRetrieveMessageBatchResultsRequest() {
        let batchId = "test_batch_123"
        let request = RetrieveMessageBatchResultsRequest(batchId: batchId)
        
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.path, "\(RequestType.batches.basePath)/\(batchId)/results")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
        XCTAssertEqual(request.batchId, batchId)
    }
}