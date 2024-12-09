//
//  OrganizationMembersTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class OrganizationMembersTests: XCTestCase {
    var session: URLSession!
    var organizationMembers: OrganizationMembers!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]
        session = URLSession(configuration: configuration)

        let apiKey = "test-api-key"
        organizationMembers = OrganizationMembers(adminAPIKey: apiKey, session: session)
    }

    func testGetOrganizationMember() async throws {
        let expectation = XCTestExpectation(description: "Get Organization Member response")

        HTTPMock.inspectType = .response("""
        {
          "id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "type": "user",
          "email": "user@emaildomain.com",
          "name": "Jane Doe",
          "role": "user",
          "added_at": "2024-10-30T23:58:27.427722Z"
        }
        """)

        let response = try await organizationMembers.get(userId: "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.type, .user)
        XCTAssertEqual(response.email, "user@emaildomain.com")
        XCTAssertEqual(response.name, "Jane Doe")
        XCTAssertEqual(response.role, .user)
        XCTAssertEqual(response.addedAt, "2024-10-30T23:58:27.427722Z")

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testRemoveOrganizationMember() async throws {
        let expectation = XCTestExpectation(description: "Remove Organization Member response")

        HTTPMock.inspectType = .response("""
        {
          "id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "type": "user_deleted"
        }
        """)

        let response = try await organizationMembers.remove(userId: "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.type, .deleted)

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testUpdateOrganizationMember() async throws {
        let expectation = XCTestExpectation(description: "Update Organization Member response")

        HTTPMock.inspectType = .response("""
        {
          "id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "type": "user",
          "email": "updated_user@emaildomain.com",
          "name": "Updated Jane Doe",
          "role": "admin",
          "added_at": "2024-10-30T23:58:27.427722Z"
        }
        """)

        let response = try await organizationMembers.update(userId: "user_01WCz1FkmYMm4gnmykNKUu3Q", role: .admin)
        XCTAssertEqual(response.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.type, .user)
        XCTAssertEqual(response.email, "updated_user@emaildomain.com")
        XCTAssertEqual(response.name, "Updated Jane Doe")
        XCTAssertEqual(response.role, .admin)
        XCTAssertEqual(response.addedAt, "2024-10-30T23:58:27.427722Z")

        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
