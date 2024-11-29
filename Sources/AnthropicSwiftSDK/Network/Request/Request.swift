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
    case delete = "DELETE"
}

enum RequestType {
    case messages
    case batches
    case countTokens
    case organizationMember
    case organizationInvite
    case workspace
    case apiKey

    var basePath: String {
        switch self {
        case .messages:
            return "/v1/messages"
        case .batches:
            return "/v1/messages/batches"
        case .countTokens:
            return "/v1/messages/count_tokens"
        case .organizationMember:
            return "/v1/organizations/users"
        case .organizationInvite:
            return "/v1/organizations/invites"
        case .workspace:
            return "/v1/organizations/workspaces"
        case .apiKey:
            return "/v1/organizations/api_keys"
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
