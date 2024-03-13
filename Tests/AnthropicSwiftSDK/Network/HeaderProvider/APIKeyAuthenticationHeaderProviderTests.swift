//
//  APIKeyAuthenticationHeaderProviderTests.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
@testable import AnthropicSwiftSDK

final class APIKeyAuthenticationHeaderProviderTests: XCTestCase {
    func testHeaderShouldContainAPIKey() {
        let provider = APIKeyAuthenticationHeaderProvider(apiKey: "test-api-key")
        let headers = provider.getAuthenticationHeaders()

        XCTAssertEqual(headers["x-api-key"], "test-api-key")
    }
}
