//
//  UpdateWorkspaceMemberRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class UpdateWorkspaceMemberRequestTests: XCTestCase {
    func testUpdateWorkspaceMemberRequest() throws {
        let userId = "test-user-id"
        let workspaceId = "test-workspace-id"
        let role = WorkspaceRole.developer
        let request = UpdateWorkspaceMemberRequest(body: .init(role: role), userId: userId, workspaceId: workspaceId)

        XCTAssertEqual(request.method, HttpMethod.post)
        XCTAssertEqual(request.path, "\(RequestType.workspaceMember(workspaceId: workspaceId).basePath)/\(userId)")
        XCTAssertNil(request.queries)
        XCTAssertNotNil(request.body)
        XCTAssertEqual(request.body?.role, role)
    }
}
