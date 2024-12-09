//
//  APIKeysTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class APIKeysTests: XCTestCase {
    var session: URLSession!
    var apiKeys: APIKeys!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]
        session = URLSession(configuration: configuration)

        let apiKey = "test-api-key"
        apiKeys = APIKeys(adminAPIKey: apiKey, session: session)
    }

    func testGetAPIKey() async throws {
        let expectation = XCTestExpectation(description: "Get API Key response")

        HTTPMock.inspectType = .response("""
        {
          "id": "apikey_01Rj2N8SVvo6BePZj99NhmiT",
          "type": "api_key",
          "name": "Developer Key",
          "workspace_id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "created_at": "2024-10-30T23:58:27.427722Z",
          "created_by": {
            "id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
            "type": "user"
          },
          "partial_key_hint": "sk-ant-api03-R2D...igAA",
          "status": "active"
        }
        """)

        let response = try await apiKeys.get(apiKeyId: "test-key-id")
        XCTAssertEqual(response.id, "apikey_01Rj2N8SVvo6BePZj99NhmiT")
        XCTAssertEqual(response.type, .apiKey)
        XCTAssertEqual(response.name, "Developer Key")
        XCTAssertEqual(response.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.createdBy.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.createdBy.type, "user")
        XCTAssertEqual(response.partialKeyHint, "sk-ant-api03-R2D...igAA")
        XCTAssertEqual(response.status, .active)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testUpdateAPIKey() async throws {
        let expectation = XCTestExpectation(description: "Update API Key response")

        HTTPMock.inspectType = .response("""
        {
          "id": "apikey_01Rj2N8SVvo6BePZj99NhmiT",
          "type": "api_key",
          "name": "Updated API Key",
          "workspace_id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "created_at": "2024-10-30T23:58:27.427722Z",
          "created_by": {
            "id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
            "type": "user"
          },
          "partial_key_hint": "sk-ant-api03-R2D...igAA",
          "status": "inactive"
        }
        """)

        let updatedResponse = try await apiKeys.update(apiKeyId: "test-key-id", name: "Updated API Key", status: .inactive)
        XCTAssertEqual(updatedResponse.id, "apikey_01Rj2N8SVvo6BePZj99NhmiT")
        XCTAssertEqual(updatedResponse.type, .apiKey)
        XCTAssertEqual(updatedResponse.name, "Updated API Key")
        XCTAssertEqual(updatedResponse.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(updatedResponse.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(updatedResponse.createdBy.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(updatedResponse.createdBy.type, "user")
        XCTAssertEqual(updatedResponse.partialKeyHint, "sk-ant-api03-R2D...igAA")
        XCTAssertEqual(updatedResponse.status, .inactive)


        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
