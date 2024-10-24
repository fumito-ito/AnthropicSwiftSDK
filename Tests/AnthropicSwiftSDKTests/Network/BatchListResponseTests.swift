//
//  BatchListResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

import XCTest
@testable import AnthropicSwiftSDK

final class BatchListResponseTests: XCTestCase {
    func testDecodeBatchListResponse() throws {
        let json = """
        {
            "data": [
                {
                    "id": "batch_123",
                    "type": "message_batch",
                    "processing_status": "ended",
                    "request_counts": {
                        "processing": 0,
                        "succeeeded": 95,
                        "errored": 5,
                        "canceled": 0,
                        "expired": 0
                    },
                    "ended_at": "2024-10-18T12:05:00Z",
                    "created_at": "2024-10-18T12:00:00Z",
                    "expires_at": "2024-10-19T12:00:00Z",
                    "cancel_initiated_at": null,
                    "results_url": "https://example.com/results/batch_123.jsonl"
                },
                {
                    "id": "batch_456",
                    "type": "message_batch",
                    "processing_status": "in_progress",
                    "request_counts": {
                        "processing": 100,
                        "succeeeded": 0,
                        "errored": 0,
                        "canceled": 0,
                        "expired": 0
                    },
                    "ended_at": null,
                    "created_at": "2024-10-18T12:10:00Z",
                    "expires_at": "2024-10-19T12:10:00Z",
                    "cancel_initiated_at": null,
                    "results_url": null
                }
            ],
            "has_more": true,
            "first_id": "batch_123",
            "last_id": "batch_456"
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        
        let response = try anthropicJSONDecoder.decode(BatchListResponse.self, from: jsonData)
        
        XCTAssertEqual(response.data.count, 2)
        
        // Test first batch
        let firstBatch = response.data[0]
        XCTAssertEqual(firstBatch.id, "batch_123")
        XCTAssertEqual(firstBatch.type, .message)
        XCTAssertEqual(firstBatch.processingStatus, .ended)
        XCTAssertEqual(firstBatch.requestCounts.processing, 0)
        XCTAssertEqual(firstBatch.requestCounts.succeeeded, 95)
        XCTAssertEqual(firstBatch.requestCounts.errored, 5)
        XCTAssertEqual(firstBatch.requestCounts.canceled, 0)
        XCTAssertEqual(firstBatch.requestCounts.expired, 0)
        XCTAssertEqual(firstBatch.endedAt, "2024-10-18T12:05:00Z")
        XCTAssertEqual(firstBatch.createdAt, "2024-10-18T12:00:00Z")
        XCTAssertEqual(firstBatch.expiresAt, "2024-10-19T12:00:00Z")
        XCTAssertNil(firstBatch.cancelInitiatedAt)
        XCTAssertEqual(firstBatch.resultsUrl, "https://example.com/results/batch_123.jsonl")
        
        // Test second batch
        let secondBatch = response.data[1]
        XCTAssertEqual(secondBatch.id, "batch_456")
        XCTAssertEqual(secondBatch.type, .message)
        XCTAssertEqual(secondBatch.processingStatus, .inProgress)
        XCTAssertEqual(secondBatch.requestCounts.processing, 100)
        XCTAssertEqual(secondBatch.requestCounts.succeeeded, 0)
        XCTAssertEqual(secondBatch.requestCounts.errored, 0)
        XCTAssertEqual(secondBatch.requestCounts.canceled, 0)
        XCTAssertEqual(secondBatch.requestCounts.expired, 0)
        XCTAssertNil(secondBatch.endedAt)
        XCTAssertEqual(secondBatch.createdAt, "2024-10-18T12:10:00Z")
        XCTAssertEqual(secondBatch.expiresAt, "2024-10-19T12:10:00Z")
        XCTAssertNil(secondBatch.cancelInitiatedAt)
        XCTAssertNil(secondBatch.resultsUrl)
        
        XCTAssertTrue(response.hasMore)
        XCTAssertEqual(response.firstId, "batch_123")
        XCTAssertEqual(response.lastId, "batch_456")
    }
}