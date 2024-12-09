//
//  GetOrganizationInviteRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class GetOrganizationInviteRequestTests: XCTestCase {
    func testGetOrganizationInviteRequest() throws {
        let invitationId = "invite-id"
        let request = GetOrganizationInviteRequest(invitationId: invitationId)

        XCTAssertEqual(request.method, HttpMethod.get)
        XCTAssertEqual(request.path, "\(RequestType.organizationInvite.basePath)/\(invitationId)")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
