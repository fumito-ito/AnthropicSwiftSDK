//
//  WorkspaceMembers.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct WorkspaceMembers {
    private let adminAPIKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.adminAPIKey = adminAPIKey
        self.session = session
    }

    public func get(userId: String, workspaceId: String) async throws -> WorkspaceMemberResponse {
        fatalError()
    }

    public func list(workspaceId: String, limit: Int = 20, beforeId: String? = nil, afterId: String? = nil) async throws -> ObjectListResponse<WorkspaceMemberResponse> {
        fatalError()
    }

    public func add(registration: Registration, wokspaceId: String) async throws -> WorkspaceMemberResponse {
        fatalError()
    }

    public func update(userId: String, workspaceId: String, as role: WorkspaceRole) async throws -> WorkspaceMemberResponse {
        fatalError()
    }

    public func delete(userId: String, workspaceId: String) async throws -> WorkspaceMemberRemoveResponse {
        fatalError()
    }
}
