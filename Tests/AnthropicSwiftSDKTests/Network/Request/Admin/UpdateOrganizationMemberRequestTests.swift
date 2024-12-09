//
//  UpdateOrganizationMemberRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class UpdateOrganizationMemberRequestTests: XCTestCase {
    func testUpdateOrganizationMemberRequest() throws {
        let userId = "test-user-id"
        let role = OrganizationRole.admin
        let request = UpdateOrganizationMemberRequest(body: .init(role: role), userId: userId)

        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.path, "\(RequestType.organizationMember.basePath)/\(userId)")
        XCTAssertNil(request.queries)
        XCTAssertNotNil(request.body)
        XCTAssertEqual(request.body?.role, role)
    }
}
