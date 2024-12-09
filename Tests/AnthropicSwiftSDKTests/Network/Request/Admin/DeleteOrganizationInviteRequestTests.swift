//
//  DeleteOrganizationInviteRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class DeleteOrganizationInviteRequestTests: XCTestCase {
    func testDeleteOrganizationInviteRequest() throws {
        let request = DeleteOrganizationInviteRequest(invitationId: "foo-bar")

        XCTAssertEqual(request.method, HttpMethod.delete)
        XCTAssertEqual(request.path, "\(RequestType.organizationInvite.basePath)/foo-bar")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
