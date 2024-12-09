//
//  RemoveOrganizationMemberRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class RemoveOrganizationMemberRequestTests: XCTestCase {
    func testRemoveOrganizationMemberRequest() throws {
        let userId = "test-user-id"
        let request = RemoveOrganizationMemberRequest(userId: userId)

        XCTAssertEqual(request.method, HttpMethod.delete)
        XCTAssertEqual(request.path, "\(RequestType.organizationMember.basePath)/\(userId)")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
