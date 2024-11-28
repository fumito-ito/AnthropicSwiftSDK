//
//  InvitationRemoveResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

/// Deleted object type for Invites, this is always "invite_deleted".
public enum InvitationDeletedType: String, Decodable {
    case deleted = "invite_deleted"
}

public struct InvitationRemoveResponse: Decodable {
    /// ID of the Invite.
    public let id: String
    /// Deleted object type for Invites, this is always "invite_deleted".
    public let type: InvitationDeletedType
}
