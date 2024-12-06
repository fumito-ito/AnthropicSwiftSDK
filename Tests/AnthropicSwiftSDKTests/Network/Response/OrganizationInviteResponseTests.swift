//
//  OrganizationInviteResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/06.
//

import XCTest
import AnthropicSwiftSDK

final class OrganizationInviteResponseTests: XCTestCase {
    func testDecodeOrganizationInviteResponse() throws {
        let json = """
        {
          "id": "invite_015gWxCN9Hfg2QhZwTK7Mdeu",
          "type": "invite",
          "email": "user@emaildomain.com",
          "role": "user",
          "invited_at": "2024-10-30T23:58:27.427722Z",
          "expires_at": "2024-11-20T23:58:27.427722Z",
          "status": "pending"
        }
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(InvitationResponse.self, from: jsonData)

        XCTAssertEqual(response.id, "invite_015gWxCN9Hfg2QhZwTK7Mdeu")
        XCTAssertEqual(response.type, .invite)
        XCTAssertEqual(response.email, "user@emaildomain.com")
        XCTAssertEqual(response.role, .user)
        XCTAssertEqual(response.invitedAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.expiresAt, "2024-11-20T23:58:27.427722Z")
        XCTAssertEqual(response.status, .pending)
    }

    func testDecodeOrganizationInviteRemoveResponse() throws {
        let json = """
        {
          "id": "invite_015gWxCN9Hfg2QhZwTK7Mdeu",
          "type": "invite_deleted"
        }
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(InvitationRemoveResponse.self, from: jsonData)

        XCTAssertEqual(response.id, "invite_015gWxCN9Hfg2QhZwTK7Mdeu")
        XCTAssertEqual(response.type, .deleted)
    }
}
