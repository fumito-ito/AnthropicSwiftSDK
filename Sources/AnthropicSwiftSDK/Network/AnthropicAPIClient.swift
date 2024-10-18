//
//  AnthropicAPIClient.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

struct APIClient {
    private let session: URLSession
    let baseURL: URL
    let anthropicHeaderProvider: AnthropicHeaderProvider
    let authenticationHeaderProvider: AuthenticationHeaderProvider

    init(
        session: URLSession = .shared,
        baseURL: URL = .init(string: "https://api.anthropic.com")!, // swiftlint:disable:this force_unwrapping
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) {
        self.session = session
        self.baseURL = baseURL
        self.anthropicHeaderProvider = anthropicHeaderProvider
        self.authenticationHeaderProvider = authenticationHeaderProvider
    }

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

    /// Send messages API request. This method receives HTTP response from API.
    ///
    /// - Parameter request: request body for api request
    /// - Returns: response from API
    func send(request: any Request) async throws -> (Data, URLResponse) {
        var urlRequest = try request.toURLRequest(for: baseURL)
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return try await session.data(for: urlRequest)
    }

    /// Send messages API request. This method read the API response sequentially.
    ///
    /// - Parameter request: request body for api request
    /// - Returns: response chunk from API
    func stream(request: any Request) async throws -> (URLSession.AsyncBytes, URLResponse) {
        var urlRequest = try request.toURLRequest(for: baseURL)
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return try await session.bytes(for: urlRequest)
    }
}
