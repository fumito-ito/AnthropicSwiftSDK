//
//  DeleteWorkspaceMemberRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class DeleteWorkspaceMemberRequestTests: XCTestCase {
    func testDeleteWorkspaceMemberRequest() throws {
        let userId = "test-user-id"
        let workspaceId = "test-workspace-id"
        let request = DeleteWorkspaceMemberRequest(userId: userId, workspaceId: workspaceId)

        XCTAssertEqual(request.method, HttpMethod.delete)
        XCTAssertEqual(request.path, "\(RequestType.workspaceMember(workspaceId: workspaceId).basePath)/\(userId)")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
