//
//  APIKeys.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct APIKeys {
    private let adminAPIKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.adminAPIKey = adminAPIKey
        self.session = session
    }

    public func get(apiKeyId: String) async throws -> APIKeyResponse {
        fatalError()
    }

    public func list(
        limit: Int = 20,
        beforeId: String? = nil,
        lastId: String? = nil,
        status: APIKeyStatus? = nil,
        workspaceId: String? = nil,
        createdByUserId: String? = nil
    ) async throws -> ObjectListResponse<APIKeyResponse> {
        fatalError()
    }

    public func update(apiKeyId: String, name: String, status: APIKeyStatus? = nil) async throws -> APIKeyResponse {
        fatalError()
    }
}
