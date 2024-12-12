//
//  MessageBatchesTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class MessageBatchesTests: XCTestCase {
    var session = URLSession.shared

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]

        session = URLSession(configuration: configuration)
    }

    func testMessageBatchesUsesProvidedAPIKey() async throws {
        let batches = MessageBatches(apiKey: "This-is-test-API-key", session: session)
        let expectation = XCTestExpectation(description: "MessageBatches uses provided api key in request header.")

        HTTPMock.inspectType = .requestHeader({ headers in
            XCTAssertEqual(headers!["x-api-key"], "This-is-test-API-key")
            expectation.fulfill()
        },
        """
        {
            "id": "batch_123456",
            "type": "message_batch",
            "processing_status": "ended",
            "request_counts": {
                "processing": 0,
                "succeeeded": 95,
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
        """)

        let batch = MessageBatch(
            customId: "This-is-custom-id",
            parameter: .init(
                messages: [
                    .init(
                        role: .user,
                        content: [
                            .text("This is test text")
                        ]
                    )
                ],
                maxTokens: 1024
            )
        )
        let _ = try await batches.createBatches(batches: [batch])

        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testCreateMessageBatchesReturnsBatchResponse() async throws {
        let batches = MessageBatches(apiKey: "This-is-test-API-key", session: session)

        HTTPMock.inspectType = .response(
        """
        {
            "id": "batch_123456",
            "type": "message_batch",
            "processing_status": "ended",
            "request_counts": {
                "processing": 0,
                "succeeeded": 95,
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
        """)

        let batch = MessageBatch(
            customId: "This-is-custom-id",
            parameter: .init(messages: [.init(role: .user, content: [.text("This is test text")])], maxTokens: 1024)
        )
        let response = try await batches.createBatches(batches: [batch])
        XCTAssertEqual(response.id, "batch_123456")
        XCTAssertEqual(response.type, .message)
        XCTAssertEqual(response.processingStatus, .ended)
        XCTAssertEqual(response.requestCounts.processing, 0)
        XCTAssertEqual(response.requestCounts.succeeeded, 95)
        XCTAssertEqual(response.requestCounts.errored, 3)
        XCTAssertEqual(response.requestCounts.canceled, 1)
        XCTAssertEqual(response.requestCounts.expired, 1)
        XCTAssertEqual(response.endedAt, "2024-10-18T15:30:00Z")
        XCTAssertEqual(response.createdAt, "2024-10-18T15:00:00Z")
        XCTAssertEqual(response.expiresAt, "2024-10-19T15:00:00Z")
        XCTAssertNil(response.cancelInitiatedAt)
        XCTAssertEqual(response.resultsUrl, "https://example.com/results/batch_123456.jsonl")
    }

    func testGetBatch() async throws {
        let batches = MessageBatches(apiKey: "This-is-test-API-key", session: session)
        
        HTTPMock.inspectType = .response("""
        {
            "id": "batch_123456",
            "type": "message_batch",
            "processing_status": "in_progress",
            "request_counts": {
                "processing": 50,
                "succeeeded": 0,
                "errored": 0,
                "canceled": 0,
                "expired": 0
            },
            "created_at": "2024-10-18T15:00:00Z",
            "expires_at": "2024-10-19T15:00:00Z",
            "cancel_initiated_at": null,
            "results_url": null
        }
        """)
        
        let response = try await batches.retrieve(batchId: "batch_123456")
        XCTAssertEqual(response.id, "batch_123456")
        XCTAssertEqual(response.type, .message)
        XCTAssertEqual(response.processingStatus, .inProgress)
        XCTAssertEqual(response.requestCounts.processing, 50)
        XCTAssertEqual(response.createdAt, "2024-10-18T15:00:00Z")
        XCTAssertEqual(response.expiresAt, "2024-10-19T15:00:00Z")
        XCTAssertNil(response.cancelInitiatedAt)
        XCTAssertNil(response.resultsUrl)
    }

    func testCancelBatch() async throws {
        let batches = MessageBatches(apiKey: "This-is-test-API-key", session: session)
        
        HTTPMock.inspectType = .response("""
        {
            "id": "batch_123456",
            "type": "message_batch",
            "processing_status": "canceling",
            "request_counts": {
                "processing": 25,
                "succeeeded": 25,
                "errored": 0,
                "canceled": 0,
                "expired": 0
            },
            "created_at": "2024-10-18T15:00:00Z",
            "expires_at": "2024-10-19T15:00:00Z",
            "cancel_initiated_at": "2024-10-18T15:30:00Z",
            "results_url": null
        }
        """)
        
        let response = try await batches.cancel(batchId: "batch_123456")
        XCTAssertEqual(response.id, "batch_123456")
        XCTAssertEqual(response.processingStatus, .canceling)
        XCTAssertEqual(response.cancelInitiatedAt, "2024-10-18T15:30:00Z")
    }

    func testGetBatchResults() async throws {
        let batches = MessageBatches(apiKey: "This-is-test-API-key", session: session)
        
        HTTPMock.inspectType = .response("""
        {"custom_id":"request_123","result":{"type":"succeeded","message":{"id":"msg_123456","type":"message","role":"assistant","model":"claude-3-opus-20240229","content":[{"type":"text","text":"Hello!"}],"stop_reason":"end_turn","stop_sequence":null,"usage":{"input_tokens":11,"output_tokens":1}}}}
        {"custom_id":"request_456","result":{"type":"errored","error":{"type":"invalid_request_error","message":"Invalid input"}}}
        """)
        
        let results = try await batches.results(of: "batch_123456")
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].customId, "request_123")
        XCTAssertEqual(results[0].result?.type, .succeeded)
        XCTAssertEqual(results[1].customId, "request_456")
        XCTAssertEqual(results[1].result?.type, .errored)
    }

    func testCreateMultipleBatches() async throws {
        let batches = MessageBatches(apiKey: "This-is-test-API-key", session: session)
        
        HTTPMock.inspectType = .response("""
        {
            "id": "batch_789012",
            "type": "message_batch",
            "processing_status": "in_progress",
            "request_counts": {
                "processing": 100,
                "succeeeded": 0,
                "errored": 0,
                "canceled": 0,
                "expired": 0
            },
            "created_at": "2024-10-18T16:00:00Z",
            "expires_at": "2024-10-19T16:00:00Z",
            "cancel_initiated_at": null,
            "results_url": null
        }
        """)
        
        let batch1 = MessageBatch(customId: "custom_id_1", parameter: .init(messages: [.init(role: .user, content: [.text("Test 1")])], maxTokens: 1024))
        let batch2 = MessageBatch(customId: "custom_id_2", parameter: .init(messages: [.init(role: .user, content: [.text("Test 2")])], maxTokens: 1024))
        let response = try await batches.createBatches(batches: [batch1, batch2])
        
        XCTAssertEqual(response.id, "batch_789012")
        XCTAssertEqual(response.processingStatus, .inProgress)
        XCTAssertEqual(response.requestCounts.processing, 100)
    }

    func testCreateBatchesWithInvalidAPIKey() async throws {
        let batches = MessageBatches(apiKey: "Invalid-API-Key", session: session)
        
        HTTPMock.inspectType = .error("""
        {
          "type": "error",
          "error": {
            "type": "invalid_request_error",
            "message": "There was an issue with the format or content of your request."
          }
        }
        """)

        let batch = MessageBatch(customId: "custom_id", parameter: .init(messages: [.init(role: .user, content: [.text("Test")])], maxTokens: 1024))
        
        do {
            let _ = try await batches.createBatches(batches: [batch])
            XCTFail("Expected an error to be thrown")
        } catch let error as AnthropicAPIError {
            XCTAssertEqual(error, .invalidRequestError)
        }
    }
    
    func testValidate_Success() {
        let batch = MessageBatch(
            customId: "",
            parameter: .init(
                messages: [
                    .init(
                        role: .user,
                        content: [
                            .text("")
                        ]
                    ),
                    .init(
                        role: .user,
                        content: [
                            .text("")
                        ]
                    )
                ],
                model: .claude_3_Opus,
                maxTokens: 1
            )
        )
        let batches = [batch]
        let messageBatches = MessageBatches(apiKey: "", session: .shared)

        XCTAssertNoThrow(try messageBatches.validate(batches: batches))
    }

    func testValidate_ModelDoesNotSupportBatches() {
        let batch = MessageBatch(
            customId: "",
            parameter: .init(
                messages: [
                    .init(
                        role: .user,
                        content: [
                            .text("")
                        ]
                    ),
                    .init(
                        role: .user,
                        content: [
                            .text("")
                        ]
                    )
                ],
                model: .claude_3_Sonnet,
                maxTokens: 1
            )
        )
        let batches = [batch]
        let messageBatches = MessageBatches(apiKey: "", session: .shared)

        XCTAssertThrowsError(try messageBatches.validate(batches: batches)) { error in
            guard let clientError = error as? ClientError else {
                XCTFail("Expected ClientError but got \(error)")
                return
            }
            switch clientError {
            case .unsupportedFeatureUsed(let description):
                XCTAssertEqual(description, "The model: \(Model.claude_3_Sonnet.stringfy) does not support Message Batches API")
            default:
                XCTFail("Unexpected ClientError: \(clientError)")
            }
        }
    }

    func testValidate_UnsupportedMessageContentContained() {
        // Arrange
        let batch = MessageBatch(
            customId: "",
            parameter: .init(
                messages: [
                    .init(
                        role: .user,
                        content: [
                            .image(.init(type: .base64, mediaType: .png, data: Data()))
                        ]
                    ),
                    .init(
                        role: .user,
                        content: [
                            .text("")
                        ]
                    )
                ],
                model: .claude_3_5_Haiku,
                maxTokens: 1
            )
        )
        let batches = [batch]
        let messageBatches = MessageBatches(apiKey: "", session: .shared)

        XCTAssertThrowsError(try messageBatches.validate(batches: batches)) { error in
            guard let clientError = error as? ClientError else {
                XCTFail("Expected ClientError but got \(error)")
                return
            }
            switch clientError {
            case .unsupportedMessageContentContained(let model, let messages):
                XCTAssertEqual(model.stringfy, Model.claude_3_5_Haiku.stringfy)
                XCTAssertEqual(messages.count, 1)
                XCTAssertEqual(messages.first?.content.first?.contentType, .image)
            default:
                XCTFail("Unexpected ClientError: \(clientError)")
            }
        }
    }
}
