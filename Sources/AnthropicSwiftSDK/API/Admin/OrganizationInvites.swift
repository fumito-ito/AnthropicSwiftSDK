//
//  OrganizationInvites.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct OrganizationInvites {
    private let adminAPIKey: String
    private let session: URLSession

    init(adminAPIKey: String, session: URLSession) {
        self.adminAPIKey = adminAPIKey
        self.session = session
    }

    public func get(invitationId: String) async throws -> InvitationResponse {
        fatalError()
    }

    public func list(limit: Int = 20, beforeId: String? = nil, afterId: String? = nil) async throws -> ObjectListResponse<InvitationResponse> {
        fatalError()
    }

    public func send(invitation: Invitation) async throws -> InvitationResponse {
        fatalError()
    }

    public func remove(invitationId: String) async throws -> InvitationRemoveResponse {
        fatalError()
    }
}
