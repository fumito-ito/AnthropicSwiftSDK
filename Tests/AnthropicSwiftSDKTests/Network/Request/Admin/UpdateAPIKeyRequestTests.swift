//
//  UpdateAPIKeyRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class UpdateAPIKeyRequestTests: XCTestCase {
    func testUpdateAPIKeyRequest() throws {
        let apiKeyId = "apikeyid"
        let newKeyName = "newkeyname"
        let request = UpdateAPIKeyRequest(body: .init(name: newKeyName, status: .inactive), apiKeyId: apiKeyId)

        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.path, "\(RequestType.apiKey.basePath)/\(apiKeyId)")
        XCTAssertNil(request.queries)
        XCTAssertNotNil(request.body)
        XCTAssertEqual(request.body?.name, newKeyName)
        XCTAssertEqual(request.body?.status, .inactive)
    }
}
