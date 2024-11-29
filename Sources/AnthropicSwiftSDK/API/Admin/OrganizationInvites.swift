//
//  OrganizationInvites.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct OrganizationInvites {
    private let apiKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.apiKey = adminAPIKey
        self.session = session
    }

    public func get(invitationId: String) async throws -> InvitationResponse {
        try await get(
            invitationId: invitationId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func get(
        invitationId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> InvitationResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: GetOrganizationInviteRequest(invitationId: invitationId))
    }

    public func list(limit: Int = 20, beforeId: String? = nil, afterId: String? = nil) async throws -> ObjectListResponse<InvitationResponse> {
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
    ) async throws -> ObjectListResponse<InvitationResponse> {
        try await list(
            session: session,
            type: .organizationInvite,
            limit: limit,
            beforeId: beforeId,
            afterId: afterId,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )
    }

    public func send(invitation: Invitation) async throws -> InvitationResponse {
        try await send(
            invitation: invitation,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func send(
        invitation: Invitation,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> InvitationResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(
            request: CreateOrganizationInviteRequest(
                body: .init(
                    email: invitation.email,
                    role: invitation.role
                )
            )
        )
    }

    public func remove(invitationId: String) async throws -> InvitationRemoveResponse {
        try await remove(
            invitationId: invitationId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func remove(
        invitationId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> InvitationRemoveResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: DeleteOrganizationInviteRequest(invitationId: invitationId))
    }
}

extension OrganizationInvites: ObjectListable {
    typealias Object = InvitationResponse
}
