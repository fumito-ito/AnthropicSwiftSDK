//
//  InvitationResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

/// Object type for Invites, this is always "invite".
public enum InvitationType: String, Decodable {
    case invite
}

/// Status of the Invite.
public enum InvitationStatus: String, Decodable {
    case accepted
    case expired
    case deleted
    case pending
}

public struct InvitationResponse: Decodable {
    /// ID of the Invite.
    public let id: String
    /// Object type for Invites, this is always "invite".
    public let type: InvitationType
    /// Email of the User being invited.
    public let email: String
    /// Organization role of the User.
    public let role: OrganizationRole
    /// RFC 3339 datetime string indicating when the Invite was created.
    public let invitedAt: String
    /// RFC 3339 datetime string indicating when the Invite expires.
    public let expiresAt: String
    /// Status of the Invite.
    public let status: InvitationStatus
}
