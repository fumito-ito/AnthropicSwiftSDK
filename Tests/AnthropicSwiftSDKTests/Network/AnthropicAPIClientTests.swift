//
//  AnthropicAPIClientTests.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import XCTest
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK

final class AnthropicAPIClientTests: XCTestCase {
    var session = URLSession.shared

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]

        session = URLSession(configuration: configuration)
    }

    func testAPITypeProvidesCorrectMethodAndPathForSend() async throws {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: "")
        )
        let expectation = XCTestExpectation(description: "APIType.message should `/v1/messages` path and `POST` method.")

        HTTPMock.inspectType = .request({ request in
            XCTAssertEqual(request.url?.path(), "/v1/messages")
            XCTAssertEqual(request.httpMethod, "POST")

            expectation.fulfill()
        })

        let _ = try await client.send(request: NopRequest())
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testAPITypeProvidesCorrectMethodAndPathForStream() async throws {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: "")
        )
        let expectation = XCTestExpectation(description: "APIType.message should `/v1/messages` path and `POST` method.")

        HTTPMock.inspectType = .request({ request in
            XCTAssertEqual(request.url?.path(), "/v1/messages")
            XCTAssertEqual(request.httpMethod, "POST")

            expectation.fulfill()
        })

        let _ = try await client.stream(request: NopRequest())
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testHeaderProviderProvidesCorrectHeadersForSend() async throws {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: "test-api-key")
        )
        let expectation = XCTestExpectation(description: "API request should have headers `x-api-key`, `anthropic-version`, `content-type` and `anthropic-beta`.")

        HTTPMock.inspectType = .requestHeader({ headers in
            XCTAssertEqual(headers!["x-api-key"], "test-api-key")
            XCTAssertEqual(headers!["anthropic-version"], "2023-06-01")
            XCTAssertEqual(headers!["Content-Type"], "application/json")
            XCTAssertEqual(headers!["anthropic-beta"], "message-batches-2024-09-24")

            expectation.fulfill()
        })

        let _ = try await client.send(request: NopRequest())
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testHeaderProviderProvidesCorrectHeadersForStream() async throws {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: "test-api-key")
        )
        let expectation = XCTestExpectation(description: "API request should have headers `x-api-key`, `anthropic-version`, `content-type` and `anthropic-beta`.")

        HTTPMock.inspectType = .requestHeader({ headers in
            XCTAssertEqual(headers!["x-api-key"], "test-api-key")
            XCTAssertEqual(headers!["anthropic-version"], "2023-06-01")
            XCTAssertEqual(headers!["Content-Type"], "application/json")
            XCTAssertEqual(headers!["anthropic-beta"], "message-batches-2024-09-24")

            expectation.fulfill()
        })

        let _ = try await client.stream(request: NopRequest())
        await fulfillment(of: [expectation], timeout: 1.0)

    }
}
