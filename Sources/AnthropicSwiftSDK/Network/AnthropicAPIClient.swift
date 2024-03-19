//
//  AnthropicAPIClient.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
}

enum APIType: String {
    case messages
//    case textCompletions

    var path: String {
        switch self {
        case .messages:
            return "/v1/messages"
        }
    }

    var method: HttpMethod {
        switch self {
        case .messages:
            return .post
        }
    }
}

struct AnthropicAPIClient {
    let endpoint = "https://api.anthropic.com"
    let type: APIType
    let anthropicHeaderProvider: AnthropicHeaderProvider
    let authenticationHeaderProvider: AuthenticationHeaderProvider
    private let session: URLSession

    private static let jsonEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        return encoder
    }()

    private var headers: [String: String] {
        var headers: [String: String] = [:]

        anthropicHeaderProvider.getAnthropicAPIHeaders().forEach { key, value in
            headers.updateValue(value, forKey: key)
        }

        authenticationHeaderProvider.getAuthenticationHeaders().forEach { key, value in
            headers.updateValue(value, forKey: key)
        }

        return headers
    }

    private var requestURL: URL? {
        guard var urlComponents = URLComponents(string: endpoint) else {
            return nil
        }

        urlComponents.path = type.path

        return urlComponents.url
    }

    private var urlRequest: URLRequest {
        guard let url = requestURL else {
            fatalError("APIClient must have requestURL")
        }

        return URLRequest(url: url)
    }

    init(
        type: APIType = .messages,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider,
        session: URLSession
    ) {
        self.type = type
        self.anthropicHeaderProvider = anthropicHeaderProvider
        self.authenticationHeaderProvider = authenticationHeaderProvider
        self.session = session
    }

    /// Send messages API request. This method receives HTTP response from API.
    ///
    /// For more detail, see https://docs.anthropic.com/claude/reference/messages_post.
    /// - Parameter requestBody: request body for api request
    /// - Returns: response from API
    func send(requestBody: MessagesRequest) async throws -> (Data, URLResponse) {
        var request = urlRequest
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = type.method.rawValue
        request.httpBody = try Self.jsonEncoder.encode(requestBody)

        return try await session.data(for: request)
    }

    /// Send messages API request. This method read the messages api response sequentially.
    ///
    /// For more detail, see https://docs.anthropic.com/claude/reference/messages-streaming.
    /// - Parameter requestBody: request body for api request
    /// - Returns: response chunk from API
    func stream(requestBody: MessagesRequest) async throws -> (URLSession.AsyncBytes, URLResponse) {
        var request = urlRequest
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = type.method.rawValue
        request.httpBody = try Self.jsonEncoder.encode(requestBody)

        return try await session.bytes(for: request)
    }
}
