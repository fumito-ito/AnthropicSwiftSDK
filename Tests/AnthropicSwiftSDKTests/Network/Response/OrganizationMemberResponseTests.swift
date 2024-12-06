//
//  OrganizationMemberResponseTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/06.
//

import XCTest
import AnthropicSwiftSDK

final class OrganizationMemberResponseTests: XCTestCase {
    func testDecodeOrganizationMemberResponse() throws {
        let json = """
        {
          "id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "type": "user",
          "email": "user@emaildomain.com",
          "name": "Jane Doe",
          "role": "user",
          "added_at": "2024-10-30T23:58:27.427722Z"
        }
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(OrganizationMemberResponse.self, from: jsonData)

        XCTAssertEqual(response.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.type, .user)
        XCTAssertEqual(response.email, "user@emaildomain.com")
        XCTAssertEqual(response.name, "Jane Doe")
        XCTAssertEqual(response.role, .user)
        XCTAssertEqual(response.addedAt, "2024-10-30T23:58:27.427722Z")
    }

    func testDecodeOrganizationMemberRemoveResponse() throws {
        let json = """
        {
          "id": "user_01WCz1FkmYMm4gnmykNKUu3Q",
          "type": "user_deleted"
        }
        """

        let jsonData = json.data(using: .utf8)!
        let response = try anthropicJSONDecoder.decode(OrganizationMemberRemoveResponse.self, from: jsonData)

        XCTAssertEqual(response.id, "user_01WCz1FkmYMm4gnmykNKUu3Q")
        XCTAssertEqual(response.type, .deleted)
    }
}
