//
//  CreateWorkspaceMemberRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class CreateWorkspaceMemberRequestTests: XCTestCase {
    func testCreateWorkspaceMemberRequest() throws {
        let registration = Registration(userId: "1234wert", workspaceRole: .developer)
        let request = CreateWorkspaceMemberRequest(body: registration, workspaceId: "test-workspace-id")

        XCTAssertEqual(request.method, HttpMethod.post)
        XCTAssertEqual(request.path, RequestType.workspaceMember(workspaceId: "test-workspace-id").basePath)
        XCTAssertNil(request.queries)
        XCTAssertNotNil(request.body)
        XCTAssertEqual(request.body?.userId, registration.userId)
        XCTAssertEqual(request.body?.workspaceRole, registration.workspaceRole)
    }
}
