//
//  WorkspaceMemberRemoveResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

public struct WorkspaceMemberRemoveResponse: Decodable {
    /// ID of the User.
    public let userId: String
    /// ID of the Workspace.
    public let workspaceId: String
    /// Deleted object type for Workspace Members, this is always
    public let type: WorkspaceMemberDeletedType
}

/// Deleted object type for Invites, this is always "invite_deleted".
public enum WorkspaceMemberDeletedType: String, Decodable {
    case deleted = "workspace_member_deleted"
}
