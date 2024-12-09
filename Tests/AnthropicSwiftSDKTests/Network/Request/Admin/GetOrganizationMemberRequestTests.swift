//
//  GetOrganizationMemberRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class GetOrganizationMemberRequestTests: XCTestCase {
    func testGetOrganizationMemberRequest() throws {
        let userId = "test-user-id"
        let request = GetOrganizationMemberRequest(userId: userId)

        XCTAssertEqual(request.method, HttpMethod.get)
        XCTAssertEqual(request.path, "\(RequestType.organizationMember.basePath)/\(userId)")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
