//
//  RequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/23.
//

import XCTest
@testable import AnthropicSwiftSDK

class RequestTests: XCTestCase {

    struct MockRequest: Request {
        typealias Body = [String: String]

        var method: HttpMethod = .post
        var path: String = "/test"
        var queries: [String: CustomStringConvertible]? = ["key": "value"]
        var body: Body? = ["test": "data"]
    }

    func testToURLRequest() throws {
        let baseURL = URL(string: "https://api.anthropic.com")!
        let mockRequest = MockRequest()

        let urlRequest = try mockRequest.toURLRequest(for: baseURL)

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.anthropic.com/test?key=value")
        XCTAssertEqual(urlRequest.httpMethod, "POST")

        let bodyData = try XCTUnwrap(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode([String: String].self, from: bodyData)
        XCTAssertEqual(decodedBody, ["test": "data"])
    }

    func testToURLRequestWithoutBody() throws {
        let baseURL = URL(string: "https://api.anthropic.com")!
        var mockRequest = MockRequest()
        mockRequest.body = nil
        mockRequest.method = .get

        let urlRequest = try mockRequest.toURLRequest(for: baseURL)

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.anthropic.com/test?key=value")
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertNil(urlRequest.httpBody)
    }

    func testToURLRequestWithoutQueries() throws {
        let baseURL = URL(string: "https://api.anthropic.com")!
        var mockRequest = MockRequest()
        mockRequest.queries = nil

        let urlRequest = try mockRequest.toURLRequest(for: baseURL)

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://api.anthropic.com/test")
        XCTAssertEqual(urlRequest.httpMethod, "POST")

        let bodyData = try XCTUnwrap(urlRequest.httpBody)
        let decodedBody = try JSONDecoder().decode([String: String].self, from: bodyData)
        XCTAssertEqual(decodedBody, ["test": "data"])
    }
}
