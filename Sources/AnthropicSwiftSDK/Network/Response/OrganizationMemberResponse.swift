//
//  OrganizationMemberResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

/// Object type for Users, this is always "user".
public enum OrganizationMemberType: String, Decodable {
    case user
}

public struct OrganizationMemberResponse: Decodable {
    /// ID of the User.
    public let id: String
    /// Object type for Users, this is always "user".
    public let type: OrganizationMemberType
    /// Email of the User.
    public let email: String
    /// Name of the User.
    public let name: String
    /// Organization role of the User.
    public let role: OrganizationRole
    /// RFC 3339 datetime string indicating when the User joined the Organization.
    public let addedAt: String
}
