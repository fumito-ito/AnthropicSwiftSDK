//
//  OrganizationMembers.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct OrganizationMembers {
    private let adminAPIKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.adminAPIKey = adminAPIKey
        self.session = session
    }

    public func get(userId: String) async throws -> OrganizationMemberResponse {
        fatalError()
    }

    public func list(limit: Int = 20, beforeId: String? = nil, afterId: String? = nil) async throws -> OrganizationMemberListResponse {
        fatalError()
    }

    public func update(userId: String, role: OrganizationRole) async throws -> OrganizationMemberResponse {
        fatalError()
    }

    public func remove(userId: String) async throws -> OrganizationMemberRemoveResponse {
        fatalError()
    }
}
