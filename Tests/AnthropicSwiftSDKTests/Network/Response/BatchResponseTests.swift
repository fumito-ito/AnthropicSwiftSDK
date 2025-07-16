//
//  BatchResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

import XCTest
@testable import AnthropicSwiftSDK

final class BatchResponseTests: XCTestCase {
    func testDecodeBatchResponse() throws {
        let json = """
        {
            "id": "batch_123456",
            "type": "message_batch",
            "processing_status": "ended",
            "request_counts": {
                "processing": 0,
                "succeeded": 95,
                "errored": 3,
                "canceled": 1,
                "expired": 1
            },
            "ended_at": "2024-10-18T15:30:00Z",
            "created_at": "2024-10-18T15:00:00Z",
            "expires_at": "2024-10-19T15:00:00Z",
            "cancel_initiated_at": null,
            "results_url": "https://example.com/results/batch_123456.jsonl"
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let batchResponse = try decoder.decode(BatchResponse.self, from: jsonData)
        
        XCTAssertEqual(batchResponse.id, "batch_123456")
        XCTAssertEqual(batchResponse.type, .message)
        XCTAssertEqual(batchResponse.processingStatus, .ended)
        
        XCTAssertEqual(batchResponse.requestCounts.processing, 0)
        XCTAssertEqual(batchResponse.requestCounts.succeeded, 95)
        XCTAssertEqual(batchResponse.requestCounts.errored, 3)
        XCTAssertEqual(batchResponse.requestCounts.canceled, 1)
        XCTAssertEqual(batchResponse.requestCounts.expired, 1)
        
        XCTAssertEqual(batchResponse.endedAt, "2024-10-18T15:30:00Z")
        XCTAssertEqual(batchResponse.createdAt, "2024-10-18T15:00:00Z")
        XCTAssertEqual(batchResponse.expiresAt, "2024-10-19T15:00:00Z")
        XCTAssertNil(batchResponse.cancelInitiatedAt)
        XCTAssertEqual(batchResponse.resultsUrl, "https://example.com/results/batch_123456.jsonl")
    }
    
    func testDecodeBatchResponseWithCancellation() throws {
        let json = """
        {
            "id": "batch_789012",
            "type": "message_batch",
            "processing_status": "canceling",
            "request_counts": {
                "processing": 50,
                "succeeded": 40,
                "errored": 10,
                "canceled": 0,
                "expired": 0
            },
            "ended_at": null,
            "created_at": "2024-10-18T16:00:00Z",
            "expires_at": "2024-10-19T16:00:00Z",
            "cancel_initiated_at": "2024-10-18T16:30:00Z",
            "results_url": null
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let batchResponse = try decoder.decode(BatchResponse.self, from: jsonData)
        
        XCTAssertEqual(batchResponse.id, "batch_789012")
        XCTAssertEqual(batchResponse.type, .message)
        XCTAssertEqual(batchResponse.processingStatus, .canceling)
        
        XCTAssertEqual(batchResponse.requestCounts.processing, 50)
        XCTAssertEqual(batchResponse.requestCounts.succeeded, 40)
        XCTAssertEqual(batchResponse.requestCounts.errored, 10)
        XCTAssertEqual(batchResponse.requestCounts.canceled, 0)
        XCTAssertEqual(batchResponse.requestCounts.expired, 0)
        
        XCTAssertNil(batchResponse.endedAt)
        XCTAssertEqual(batchResponse.createdAt, "2024-10-18T16:00:00Z")
        XCTAssertEqual(batchResponse.expiresAt, "2024-10-19T16:00:00Z")
        XCTAssertEqual(batchResponse.cancelInitiatedAt, "2024-10-18T16:30:00Z")
        XCTAssertNil(batchResponse.resultsUrl)
    }
}
