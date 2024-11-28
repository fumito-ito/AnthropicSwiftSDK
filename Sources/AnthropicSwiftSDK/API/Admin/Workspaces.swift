//
//  Workspaces.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct Workspaces {
    private let adminAPIKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.adminAPIKey = adminAPIKey
        self.session = session
    }

    public func get(workspaceId: String) async throws -> WorkspaceResponse {
        fatalError()
    }

    public func list(limit: Int = 20, includeArchive: Bool = false, beforeId: String? = nil, afterId: String? = nil) async throws -> WorkspaceListResponse {
        fatalError()
    }

    public func update(name: String, workspaceId: String) async throws -> WorkspaceResponse {
        fatalError()
    }

    public func create(name: String) async throws -> WorkspaceResponse {
        fatalError()
    }

    public func archive(_ workspaceId: String) async throws -> WorkspaceResponse {
        fatalError()
    }
}
