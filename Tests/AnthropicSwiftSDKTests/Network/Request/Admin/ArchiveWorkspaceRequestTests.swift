//
//  ArchiveWorkspaceRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class ArchiveWorkspaceRequestTests: XCTestCase {
    func testArchiveWorkspaceRequest() throws {
        let request = ArchiveWorkspaceRequest(workspaceId: "test-workspace-id")

        XCTAssertEqual(request.method, HttpMethod.post)
        XCTAssertEqual(request.path, "\(RequestType.workspace.basePath)/test-workspace-id/archive")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
