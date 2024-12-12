//
//  OrganizationMembers.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct OrganizationMembers {
    let apiKey: String
    let session: URLSession

    init(adminAPIKey apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }

    public func get(userId: String) async throws -> OrganizationMemberResponse {
        try await get(
            userId: userId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func get(
        userId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> OrganizationMemberResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: GetOrganizationMemberRequest(userId: userId))
    }

    public func list(limit: Int = 20, beforeId: String? = nil, afterId: String? = nil) async throws -> ObjectListResponse<OrganizationMemberResponse> {
        try await list(
            limit: limit,
            beforeId: beforeId,
            afterId: afterId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func list(
        limit: Int = 20,
        beforeId: String? = nil,
        afterId: String? = nil,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> ObjectListResponse<OrganizationMemberResponse> {
        try await list(
            session: session,
            type: .organizationMember,
            limit: limit,
            beforeId: beforeId,
            afterId: afterId,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )
    }

    public func update(userId: String, role: OrganizationRole) async throws -> OrganizationMemberResponse {
        try await update(
            userId: userId,
            role: role,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func update(
        userId: String,
        role: OrganizationRole,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> OrganizationMemberResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: UpdateOrganizationMemberRequest(body: .init(role: role), userId: userId))
    }

    public func remove(userId: String) async throws -> OrganizationMemberRemoveResponse {
        try await remove(
            userId: userId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func remove(
        userId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> OrganizationMemberRemoveResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: RemoveOrganizationMemberRequest(userId: userId))
    }
}

extension OrganizationMembers: ObjectListable {
    typealias Object = OrganizationMemberResponse
}
