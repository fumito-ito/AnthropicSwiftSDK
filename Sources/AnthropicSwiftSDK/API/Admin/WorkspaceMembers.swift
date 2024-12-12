//
//  WorkspaceMembers.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct WorkspaceMembers {
    private let apiKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.apiKey = adminAPIKey
        self.session = session
    }

    public func get(userId: String, workspaceId: String) async throws -> WorkspaceMemberResponse {
        try await get(
            userId: userId,
            workspaceId: workspaceId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func get(
        userId: String,
        workspaceId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceMemberResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: GetWorkspaceMemberRequest(workspaceId: workspaceId, userId: userId))
    }

    public func list(workspaceId: String, limit: Int = 20, beforeId: String? = nil, afterId: String? = nil) async throws -> ObjectListResponse<WorkspaceMemberResponse> {
        try await list(
            workspaceId: workspaceId,
            limit: limit,
            beforeId: beforeId,
            afterId: afterId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func list(
        workspaceId: String,
        limit: Int = 20,
        beforeId: String? = nil,
        afterId: String? = nil,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> ObjectListResponse<WorkspaceMemberResponse> {
        try await list(
            session: session,
            type: .workspaceMember(workspaceId: workspaceId),
            limit: limit,
            beforeId: beforeId,
            afterId: afterId,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )
    }

    public func add(registration: Registration, workspaceId: String) async throws -> WorkspaceMemberResponse {
        try await add(
            registration: registration,
            workspaceId: workspaceId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func add(
        registration: Registration,
        workspaceId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceMemberResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(
            request: CreateWorkspaceMemberRequest(
                body: registration,
                workspaceId: workspaceId
            )
        )
    }

    public func update(userId: String, workspaceId: String, role: WorkspaceRole) async throws -> WorkspaceMemberResponse {
        try await update(
            userId: userId,
            workspaceId: workspaceId,
            role: role,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func update(
        userId: String,
        workspaceId: String,
        role: WorkspaceRole,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceMemberResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: UpdateWorkspaceMemberRequest(body: .init(role: role), userId: userId, workspaceId: workspaceId))
    }

    public func remove(userId: String, workspaceId: String) async throws -> WorkspaceMemberRemoveResponse {
        try await remove(
            userId: userId,
            workspaceId: workspaceId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func remove(
        userId: String,
        workspaceId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceMemberRemoveResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: DeleteWorkspaceMemberRequest(userId: userId, workspaceId: workspaceId))
    }
}

extension WorkspaceMembers: ObjectListable {
    typealias Object = WorkspaceMemberResponse
}
