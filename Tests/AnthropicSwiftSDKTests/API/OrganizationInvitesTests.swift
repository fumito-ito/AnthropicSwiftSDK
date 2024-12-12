//
//  OrganizationInvitesTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class OrganizationInvitesTests: XCTestCase {
    var session: URLSession!
    var organizationInvites: OrganizationInvites!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]
        session = URLSession(configuration: configuration)

        let apiKey = "test-api-key"
        organizationInvites = OrganizationInvites(adminAPIKey: apiKey, session: session)
    }

    func testGetOrganizationInvite() async throws {
        let expectation = XCTestExpectation(description: "Get Organization Invite response")

        HTTPMock.inspectType = .response("""
        {
          "id": "invite_015gWxCN9Hfg2QhZwTK7Mdeu",
          "type": "invite",
          "email": "user@emaildomain.com",
          "role": "user",
          "invited_at": "2024-10-30T23:58:27.427722Z",
          "expires_at": "2024-11-20T23:58:27.427722Z",
          "status": "pending"
        }
        """)

        let response = try await organizationInvites.get(invitationId: "invite_015gWxCN9Hfg2QhZwTK7Mdeu")
        XCTAssertEqual(response.id, "invite_015gWxCN9Hfg2QhZwTK7Mdeu")
        XCTAssertEqual(response.type, .invite)
        XCTAssertEqual(response.email, "user@emaildomain.com")
        XCTAssertEqual(response.role, .user)
        XCTAssertEqual(response.invitedAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.expiresAt, "2024-11-20T23:58:27.427722Z")
        XCTAssertEqual(response.status, .pending)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testRemoveOrganizationInvite() async throws {
        let expectation = XCTestExpectation(description: "Remove Organization Invite response")

        HTTPMock.inspectType = .response("""
        {
          "id": "invite_015gWxCN9Hfg2QhZwTK7Mdeu",
          "type": "invite_deleted"
        }
        """)

        let response = try await organizationInvites.remove(invitationId: "invite_015gWxCN9Hfg2QhZwTK7Mdeu")
        XCTAssertEqual(response.id, "invite_015gWxCN9Hfg2QhZwTK7Mdeu")
        XCTAssertEqual(response.type, .deleted)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testSendOrganizationInvite() async throws {
        let expectation = XCTestExpectation(description: "Send Organization Invite response")

        HTTPMock.inspectType = .response("""
        {
          "id": "invite_015gWxCN9Hfg2QhZwTK7Mdeu",
          "type": "invite",
          "email": "user@emaildomain.com",
          "role": "user",
          "invited_at": "2024-10-30T23:58:27.427722Z",
          "expires_at": "2024-11-20T23:58:27.427722Z",
          "status": "pending"
        }
        """)

        let invite = Invitation(email: "user@emaildomain.com", role: .user)
        let response = try await organizationInvites.send(invitation: invite)
        XCTAssertEqual(response.id, "invite_015gWxCN9Hfg2QhZwTK7Mdeu")
        XCTAssertEqual(response.type, .invite)
        XCTAssertEqual(response.email, "user@emaildomain.com")
        XCTAssertEqual(response.role, .user)
        XCTAssertEqual(response.invitedAt, "2024-10-30T23:58:27.427722Z")
        XCTAssertEqual(response.expiresAt, "2024-11-20T23:58:27.427722Z")
        XCTAssertEqual(response.status, .pending)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
