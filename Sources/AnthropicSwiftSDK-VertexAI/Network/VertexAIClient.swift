//
//  VertexAIClient.swift
//
//
//  Created by 伊藤史 on 2024/04/04.
//

import Foundation
import AnthropicSwiftSDK

enum HttpMethod: String {
    case post = "POST"
}

struct VertexAIClient {
    let region: SupportedRegion
    let projectId: String
    let modelName: String
    private let apiKey: String

    var anthropicVersion: String {
        AnthropicVersion.custom("vertex-2023-10-16").stringfy
    }

    var host: String {
        "https://\(region.rawValue)-aiplatform.googleapis.com"
    }

    var path: String {
        "/v1/projects/\(projectId)/locations/\(region.rawValue)/publishers/anthropic/models/\(modelName):streamRawPredict"
    }

    var method: HttpMethod {
        .post
    }

    var headers: [String: String] {
        [
            "x-goog-api-key": apiKey,
            "content-type": "application/json"
        ]
    }

    var requestURL: URL? {
        guard var urlComponents = URLComponents(string: host) else {
            return nil
        }
        urlComponents.path = path

        return urlComponents.url
    }

    var request: URLRequest {
        guard let requestURL else {
            fatalError()
        }

        return URLRequest(url: requestURL)
    }

    let session: URLSession

    init(location: SupportedRegion, projectId: String, modelName: String, apiKey: String, session: URLSession = .shared) {
        self.region = location
        self.projectId = projectId
        self.modelName = modelName
        self.apiKey = apiKey
        self.session = session
    }

    func send(requestBody: MessagesRequest) async throws -> (Data, URLResponse) {
        var request = request
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method.rawValue
        request.httpBody = try requestBody.encode(with: ["anthropic_version": anthropicVersion])

        return try await session.data(for: request)
    }

    func stream(requestBody: MessagesRequest) async throws -> (URLSession.AsyncBytes, URLResponse) {
        var request = request
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method.rawValue
        request.httpBody = try requestBody.encode(with: ["anthropic_version": anthropicVersion])

        return try await session.bytes(for: request)
    }
}
