//
//  OrganizationMemberRemoveResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

/// Deleted object type for Users, this is always "user_deleted".
public enum OrganizationMemberDeletedType: String, Decodable {
    case deleted = "user_deleted"
}

public struct OrganizationMemberRemoveResponse: Decodable {
    /// ID of the User.
    public let id: String
    /// Deleted object type for Users, this is always "user_deleted".
    public let type: OrganizationMemberDeletedType
}
