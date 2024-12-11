//
//  APIKeys.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct APIKeys {
    private let apiKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.apiKey = adminAPIKey
        self.session = session
    }

    public func get(apiKeyId: String) async throws -> APIKeyResponse {
        try await get(
            apiKeyId: apiKeyId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func get(
        apiKeyId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> APIKeyResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: GetAPIKeyRequest(apiKeyId: apiKeyId))
    }

    public func list(
        limit: Int = 20,
        beforeId: String? = nil,
        afterId: String? = nil,
        status: APIKeyStatus? = nil,
        workspaceId: String? = nil,
        createdByUserId: String? = nil
    ) async throws -> ObjectListResponse<APIKeyResponse> {
        fatalError("not implemented")
    }

    public func list(
        limit: Int = 20,
        beforeId: String? = nil,
        afterId: String? = nil,
        status: APIKeyStatus? = nil,
        workspaceId: String? = nil,
        createdByUserId: String? = nil,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> ObjectListResponse<APIKeyResponse> {
        try await list(
            session: session,
            type: .apiKey,
            limit: limit,
            beforeId: beforeId,
            afterId: afterId,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )
    }

    public func update(apiKeyId: String, name: String, status: APIKeyStatus? = nil) async throws -> APIKeyResponse {
        try await update(
            apiKeyId: apiKeyId,
            name: name,
            status: status,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func update(
        apiKeyId: String,
        name: String,
        status: APIKeyStatus? = nil,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> APIKeyResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(
            request: UpdateAPIKeyRequest(
                body: .init(name: name, status: status),
                apiKeyId: apiKeyId
            )
        )
    }
}

extension APIKeys: ObjectListable {
    typealias Object = APIKeyResponse
}
