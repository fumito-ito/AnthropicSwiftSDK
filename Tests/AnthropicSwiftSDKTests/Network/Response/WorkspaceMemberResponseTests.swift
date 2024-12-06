//
//  WorkspaceMemberResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/06.
//

import XCTest
import AnthropicSwiftSDK

final class WorkspaceMemberResponseTests: XCTestCase {
    func testDecodeWorkspaceMemberResponse() throws {
        let json = """
        {
          "type": "workspace_member",
          "user_id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "workspace_id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "workspace_role": "workspace_user"
        }
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(WorkspaceMemberResponse.self, from: jsonData)

        XCTAssertEqual(response.type, .workspaceMember)
        XCTAssertEqual(response.userId, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.workspaceRole, .user)
    }

    func testDecodeWorkspaceMemberRemoveResponse() throws {
        let json = """
        {
          "user_id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "workspace_id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "type": "workspace_member_deleted"
        }
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(WorkspaceMemberRemoveResponse.self, from: jsonData)

        XCTAssertEqual(response.userId, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.type, .deleted)
    }
}
