//
//  DefaultAnthropicHeaderProviderTests.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
@testable import AnthropicSwiftSDK

final class DefaultAnthropicHeaderProviderTests: XCTestCase {
    func testDefaultValue() {
        let provider = DefaultAnthropicHeaderProvider()

        XCTAssertEqual(provider.contentType, "application/json")
        XCTAssertEqual(provider.useBeta, true)
        XCTAssertEqual(provider.version, .v2023_06_01)
    }

    func testDefaultHeaders() {
        let provider = DefaultAnthropicHeaderProvider()
        let headers = provider.getAnthropicAPIHeaders()

        XCTAssertEqual(headers["content-type"], "application/json")
        XCTAssertEqual(headers["anthropic-version"], AnthropicVersion.v2023_06_01.stringfy)
    }

    func testBetaHeaderShouldBeProvidedIfUseBeta() {
        let provider = DefaultAnthropicHeaderProvider(useBeta: true)
        let headers = provider.getAnthropicAPIHeaders()

        XCTAssertEqual(headers["anthropic-beta"], "message-batches-2024-09-24,computer-use-2024-10-22,prompt-caching-2024-07-31")
    }

    func testBetaHeaderShouldNotBeProvidedIfUseBeta() {
        let provider = DefaultAnthropicHeaderProvider(useBeta: false)
        let headers = provider.getAnthropicAPIHeaders()

        XCTAssertNil(headers.index(forKey: "anthropic-beta"))
    }

    func testCustomAnthropicVersionShouldBeProvidedIfSet() {
        let provider = DefaultAnthropicHeaderProvider(version: .custom("custom-anthropic-version"))
        let headers = provider.getAnthropicAPIHeaders()

        XCTAssertEqual(headers["anthropic-version"], "custom-anthropic-version")
    }
}

extension AnthropicVersion: Equatable {
    public static func == (lhs: AnthropicVersion, rhs: AnthropicVersion) -> Bool {
        lhs.stringfy == rhs.stringfy
    }
}
