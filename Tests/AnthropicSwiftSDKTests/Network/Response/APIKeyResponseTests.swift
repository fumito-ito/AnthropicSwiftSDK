//
//  APIKeyResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/06.
//

import XCTest
import AnthropicSwiftSDK

final class APIKeyResponseTests: XCTestCase {
    func testDecodeAPIKeyResponse() throws {
        let json = """
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
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(APIKeyResponse.self, from: jsonData)

        XCTAssertEqual(response.id, "apikey_01Rj2N8SVvo6BePZj99NhmiT")
        XCTAssertEqual(response.type, .apiKey)
        XCTAssertEqual(response.name, "Developer Key")
        XCTAssertEqual(response.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.createdBy.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.createdBy.type, "user")
        XCTAssertEqual(response.partialKeyHint, "sk-ant-api03-R2D...igAA")
        XCTAssertEqual(response.status, .active)
    }
}
