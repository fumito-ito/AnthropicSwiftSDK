//
//  GetAPIKeyRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/07.
//

import XCTest
@testable import AnthropicSwiftSDK

final class GetAPIKeyRequestTests: XCTestCase {
    func testGetAPIKeyRequest() throws {
        let request = GetAPIKeyRequest(apiKeyId: "apikeyid")

        XCTAssertEqual(request.method, HttpMethod.get)
        XCTAssertEqual(request.path, "\(RequestType.apiKey.basePath)/apikeyid")
        XCTAssertNil(request.queries)
        XCTAssertNil(request.body)
    }
}
