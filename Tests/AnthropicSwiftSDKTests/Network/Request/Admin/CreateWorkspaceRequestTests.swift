//
//  CreateWorkspaceRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class CreateWorkspaceRequestTests: XCTestCase {
    func testCreateWorkspaceRequest() throws {
        let request = CreateWorkspaceRequest(body: .init(name: "Test Workspace"))

        XCTAssertEqual(request.method, HttpMethod.post)
        XCTAssertEqual(request.path, RequestType.workspace.basePath)
        XCTAssertNil(request.queries)
        XCTAssertNotNil(request.body)
        XCTAssertEqual(request.body?.name, "Test Workspace")
    }
}
