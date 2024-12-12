//
//  CreateOrganizationInviteRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class CreateOrganizationInviteRequestTests: XCTestCase {
    func testCreateOrganizationInviteRequest() throws {
        let invite = Invitation(email: "test@example.com", role: .user)
        let request = CreateOrganizationInviteRequest(body: invite)

        XCTAssertEqual(request.method, HttpMethod.post)
        XCTAssertEqual(request.path, RequestType.organizationInvite.basePath)
        XCTAssertNil(request.queries)
        XCTAssertNotNil(request.body)
        XCTAssertEqual(request.body?.email, invite.email)
        XCTAssertEqual(request.body?.role, invite.role)
    }
}
