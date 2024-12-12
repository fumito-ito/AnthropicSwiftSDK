//
//  Workspaces.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct Workspaces {
    private let apiKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.apiKey = adminAPIKey
        self.session = session
    }

    public func get(workspaceId: String) async throws -> WorkspaceResponse {
        try await get(
            workspaceId: workspaceId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func get(
        workspaceId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: GetWorkspaceRequest(workspaceId: workspaceId))
    }

    public func list(limit: Int = 20, includeArchive: Bool = false, beforeId: String? = nil, afterId: String? = nil) async throws -> ObjectListResponse<WorkspaceResponse> {
        try await list(
            limit: limit,
            includeArchive: includeArchive,
            beforeId: beforeId,
            afterId: afterId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func list(
        limit: Int = 20,
        includeArchive: Bool = false,
        beforeId: String? = nil,
        afterId: String? = nil,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> ObjectListResponse<WorkspaceResponse> {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let queries: [String: CustomStringConvertible] = {
            var queries: [String: CustomStringConvertible] = [ListObjectRequest.Parameter.limit.rawValue: limit]
            queries["include_archived"] = includeArchive
            if let beforeId {
                queries[ListObjectRequest.Parameter.beforeId.rawValue] = beforeId
            }
            if let afterId {
                queries[ListObjectRequest.Parameter.afterId.rawValue] = afterId
            }
            return queries
        }()

        return try await client.send(request: ListObjectRequest(queries: queries, type: .workspace))
    }

    public func update(name: String, workspaceId: String) async throws -> WorkspaceResponse {
        try await update(
            name: name,
            workspaceId: workspaceId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func update(
        name: String,
        workspaceId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: UpdateWorkspaceRequest(body: .init(name: name), workspaceId: workspaceId))
    }

    public func create(name: String) async throws -> WorkspaceResponse {
        try await create(
            name: name,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func create(
        name: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: CreateWorkspaceRequest(body: .init(name: name)))
    }

    public func archive(_ workspaceId: String) async throws -> WorkspaceResponse {
        try await archive(
            workspaceId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    public func archive(
        _ workspaceId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> WorkspaceResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        return try await client.send(request: ArchiveWorkspaceRequest(workspaceId: workspaceId))
    }
}

extension Workspaces: ObjectListable {
    typealias Object = WorkspaceResponse
}
