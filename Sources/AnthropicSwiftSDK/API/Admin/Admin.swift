//
//  Admin.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//
import Foundation

public struct Admin {
    public let organizationMembers: OrganizationMembers
    public let organizationInvites: OrganizationInvites
    public let workspaces: Workspaces
    public let workspaceMembers: WorkspaceMembers
    public let apiKeys: APIKeys

    public init(adminAPIKey apiKey: String, session: URLSession = .shared) {
        self.organizationMembers = OrganizationMembers(adminAPIKey: apiKey, session: session)
        self.organizationInvites = OrganizationInvites(adminAPIKey: apiKey, session: session)
        self.workspaces = Workspaces(adminAPIKey: apiKey, session: session)
        self.workspaceMembers = WorkspaceMembers(adminAPIKey: apiKey, session: session)
        self.apiKeys = APIKeys(adminAPIKey: apiKey, session: session)
    }
}
