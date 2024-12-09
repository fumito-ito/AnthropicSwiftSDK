//
//  WorkspaceMemberResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

public enum WorkspaceMemberType: String, Decodable {
    case workspaceMember = "workspace_member"
}

public struct WorkspaceMemberResponse: Decodable {
    /// Object type for Workspace Members, this is always
    public let type: WorkspaceMemberType
    /// ID of the User.
    public let userId: String
    /// ID of the Workspace.
    public let workspaceId: String
    /// Role of the Workspace Member.
    public let workspaceRole: WorkspaceRole
}
