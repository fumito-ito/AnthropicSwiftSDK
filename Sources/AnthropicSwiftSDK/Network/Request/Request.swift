//
//  Request.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/13.
//

import Foundation

public enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum RequestType {
    case messages
    case batches
    case countTokens

    var basePath: String {
        switch self {
        case .messages:
            return "/v1/messages"
        case .batches:
            return "/v1/messages/batches"
        case .countTokens:
            return "v1/messages/count_tokens"
        }
    }
}

public protocol Request {
    associatedtype Body: Encodable

    var method: HttpMethod { get }
    var path: String { get }
    var queries: [String: CustomStringConvertible]? { get }
    var body: Body? { get }
}

extension Request {
    func toURLRequest(for baseURL: URL) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body {
            request.httpBody = try anthropicJSONEncoder.encode(body)
        }

        if let queries {
            request.url?.append(queryItems: queries.map { .init(name: $0.key, value: $0.value.description) })
        }

        return request
    }
}
