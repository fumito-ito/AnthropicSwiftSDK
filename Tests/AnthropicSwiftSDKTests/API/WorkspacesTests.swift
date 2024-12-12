//
//  WorkspacesTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class WorkspacesTests: XCTestCase {
    var session: URLSession!
    var workspaces: Workspaces!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]
        session = URLSession(configuration: configuration)

        let apiKey = "test-api-key"
        workspaces = Workspaces(adminAPIKey: apiKey, session: session)
    }

    func testGetWorkspace() async throws {
        let expectation = XCTestExpectation(description: "Get Workspace response")

        HTTPMock.inspectType = .response("""
        {
          "id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "type": "workspace",
          "name": "Workspace Name",
          "created_at": "2024-10-30T23:58:27.427722Z",
          "archived_at": "2024-11-01T23:59:27.427722Z",
          "display_color": "#6C5BB9"
        }
        """)

        let response = try await workspaces.get(workspaceId: "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.id, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.type, .workspace)
        XCTAssertEqual(response.name, "Workspace Name")
        XCTAssertEqual(response.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.archivedAt, "2024-11-01T23:59:27.427722Z")
        XCTAssertEqual(response.displayColor, "#6C5BB9")

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testCreateWorkspace() async throws {
        let expectation = XCTestExpectation(description: "Create Workspace response")

        HTTPMock.inspectType = .response("""
        {
          "id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "type": "workspace",
          "name": "New Workspace",
          "created_at": "2024-10-30T23:58:27.427722Z",
          "archived_at": null,
          "display_color": "#6C5BB9"
        }
        """)

        let response = try await workspaces.create(name: "New Workspace")
        XCTAssertEqual(response.id, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.type, .workspace)
        XCTAssertEqual(response.name, "New Workspace")
        XCTAssertEqual(response.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertNil(response.archivedAt)
        XCTAssertEqual(response.displayColor, "#6C5BB9")

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testArchiveWorkspace() async throws {
        let expectation = XCTestExpectation(description: "Archive Workspace response")

        HTTPMock.inspectType = .response("""
        {
          "id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "type": "workspace",
          "name": "Workspace Name",
          "created_at": "2024-10-30T23:58:27.427722Z",
          "archived_at": "2024-11-01T23:59:27.427722Z",
          "display_color": "#6C5BB9"
        }
        """)

        let response = try await workspaces.archive("wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.id, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.type, .workspace)
        XCTAssertEqual(response.name, "Workspace Name")
        XCTAssertEqual(response.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.archivedAt, "2024-11-01T23:59:27.427722Z")
        XCTAssertEqual(response.displayColor, "#6C5BB9")

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testUpdateWorkspace() async throws {
        let expectation = XCTestExpectation(description: "Update Workspace response")

        HTTPMock.inspectType = .response("""
        {
          "id": "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ",
          "type": "workspace",
          "name": "Updated Workspace Name",
          "created_at": "2024-10-30T23:58:27.427722Z",
          "archived_at": "2024-11-01T23:59:27.427722Z",
          "display_color": "#6C5BB9"
        }
        """)

        let response = try await workspaces.update(name: "Updated Workspace Name", workspaceId: "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.id, "wrkspc_01JwQvzr7rXLA5AGx3HKfFUJ")
        XCTAssertEqual(response.type, .workspace)
        XCTAssertEqual(response.name, "Updated Workspace Name")
        XCTAssertEqual(response.createdAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.archivedAt, "2024-11-01T23:59:27.427722Z")
        XCTAssertEqual(response.displayColor, "#6C5BB9")

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}