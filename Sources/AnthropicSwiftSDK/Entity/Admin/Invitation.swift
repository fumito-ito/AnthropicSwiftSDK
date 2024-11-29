//
//  Invitation.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

public struct Invitation: Encodable {
    /// Email of the User.
    public let email: String
    /// Role for the invited User. Cannot be "admin".
    public let role: OrganizationRole
}
