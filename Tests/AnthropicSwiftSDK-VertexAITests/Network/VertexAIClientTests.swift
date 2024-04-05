//
//  VertexAIClientTests.swift
//
//
//  Created by 伊藤史 on 2024/04/05.
//

import XCTest
import AnthropicSwiftSDK
import AnthropicSwiftSDK_TestUtils
@testable import AnthropicSwiftSDK_VertexAI

final class VertexAIClientTests: XCTestCase {
    var session = URLSession.shared

    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [HTTPMock.self]

        session = URLSession(configuration: configuration)
    }

    func testAPITypeProvidesCorrectMethodAndPathForSend() async throws {
        let client = VertexAIClient(
            projectId: "test-project-id",
            accessToken: "test-access-token",
            region: .usCentral1,
            modelName: try Model.claude_3_Haiku.vertexAIModelName,
            session: session
        )
        let expectation = XCTestExpectation(description: "APIType.message should have correct path and `POST` method.")

        HTTPMock.inspectType = .request({ request in
            XCTAssertEqual(request.url?.path(), "/v1/projects/test-project-id/locations/us-central1/publishers/anthropic/models/claude-3-haiku@20240307:streamRawPredict")
            XCTAssertEqual(request.httpMethod, "POST")

            expectation.fulfill()
        })

        let _ = try await client.send(requestBody: .nop)
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testAPITypeProvidesCorrectMethodAndPathForStream() async throws {
        let client = VertexAIClient(
            projectId: "test-project-id",
            accessToken: "test-access-token",
            region: .usCentral1,
            modelName: try Model.claude_3_Haiku.vertexAIModelName,
            session: session
        )
        let expectation = XCTestExpectation(description: "APIType.message should have the correct path and `POST` method.")

        HTTPMock.inspectType = .request({ request in
            XCTAssertEqual(request.url?.path(), "/v1/projects/test-project-id/locations/us-central1/publishers/anthropic/models/claude-3-haiku@20240307:streamRawPredict")
            XCTAssertEqual(request.httpMethod, "POST")

            expectation.fulfill()
        })

        let _ = try await client.stream(requestBody: .nop)
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testHeaderProviderProvidesCorrectHeadersForSend() async throws {
        let client = VertexAIClient(
            projectId: "test-project-id",
            accessToken: "test-access-token",
            region: .usCentral1,
            modelName: try Model.claude_3_Haiku.vertexAIModelName,
            session: session
        )
        let expectation = XCTestExpectation(description: "API request should have headers `Authorization` and `content-type`.")

        HTTPMock.inspectType = .requestHeader({ headers in
            XCTAssertEqual(headers!["Authorization"], "Bearer test-access-token")
            XCTAssertEqual(headers!["Content-Type"], "application/json")

            expectation.fulfill()
        })

        let _ = try await client.send(requestBody: .nop)
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testHeaderProviderProvidesCorrectHeadersForStream() async throws {
        let client = VertexAIClient(
            projectId: "test-project-id",
            accessToken: "test-access-token",
            region: .usCentral1,
            modelName: try Model.claude_3_Haiku.vertexAIModelName,
            session: session
        )
        let expectation = XCTestExpectation(description: "API request should have headers `Authorization` and `content-type`.")

        HTTPMock.inspectType = .requestHeader({ headers in
            XCTAssertEqual(headers!["Authorization"], "Bearer test-access-token")
            XCTAssertEqual(headers!["Content-Type"], "application/json")

            expectation.fulfill()
        })

        let _ = try await client.stream(requestBody: .nop)
        await fulfillment(of: [expectation], timeout: 1.0)

    }
}
