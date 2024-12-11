//
//  GetWorkspaceMemberRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class GetWorkspaceMemberRequestTests: XCTestCase {
    func testGetWorkspaceMemberRequest() throws {
        let userId = "test-user-id"
        let workspaceId = "test-workspace-id"
        let request = GetWorkspaceMemberRequest(workspaceId: workspaceId, userId: userId)

        XCTAssertEqual(request.method, HttpMethod.get)
        XCTAssertEqual(request.path, "\(RequestType.workspaceMember(workspaceId: workspaceId).basePath)/\(userId)")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
