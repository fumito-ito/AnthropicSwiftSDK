//
//  GetWorkspaceRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class GetWorkspaceRequestTests: XCTestCase {
    func testGetWorkspaceRequest() throws {
        let workspaceId = "test-workspace-id"
        let request = GetWorkspaceRequest(workspaceId: workspaceId)

        XCTAssertEqual(request.method, HttpMethod.get)
        XCTAssertEqual(request.path, "\(RequestType.workspace.basePath)/\(workspaceId)")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
