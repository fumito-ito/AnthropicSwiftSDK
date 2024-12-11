//
//  WorkspaceMembersTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class WorkspaceMembersTests: XCTestCase {
    var session: URLSession!
    var workspaceMembers: WorkspaceMembers!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]
        session = URLSession(configuration: configuration)

        let apiKey = "test-api-key"
        workspaceMembers = WorkspaceMembers(adminAPIKey: apiKey, session: session)
    }

    func testGetWorkspaceMember() async throws {
        let expectation = XCTestExpectation(description: "Get Workspace Member response")

        HTTPMock.inspectType = .response("""
        {
          "type": "workspace_member",
          "user_id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "workspace_id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "workspace_role": "workspace_user"
        }
        """)

        let response = try await workspaceMembers.get(userId: "user_01WCz1FkmYMm4gnmykNKUu3Q", workspaceId: "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.userId, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.workspaceRole, .user)
        XCTAssertEqual(response.type, .workspaceMember)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testRemoveWorkspaceMember() async throws {
        let expectation = XCTestExpectation(description: "Remove Workspace Member response")

        HTTPMock.inspectType = .response("""
        {
          "user_id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "workspace_id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "type": "workspace_member_deleted"
        }
        """)

        let response = try await workspaceMembers.remove(userId: "user_01WCz1FkmYMm4gnmykNKUu3Q", workspaceId: "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.userId, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.type, .deleted)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testUpdateWorkspaceMember() async throws {
        let expectation = XCTestExpectation(description: "Update Workspace Member response")

        HTTPMock.inspectType = .response("""
        {
          "type": "workspace_member",
          "user_id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "workspace_id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "workspace_role": "workspace_admin"
        }
        """)

        let response = try await workspaceMembers.update(userId: "user_01WCz1FkmYMm4gnmykNKUu3Q", workspaceId: "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ", role: .admin)
        XCTAssertEqual(response.userId, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.workspaceId, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.workspaceRole, .admin)
        XCTAssertEqual(response.type, .workspaceMember)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
