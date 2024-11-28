//
//  WorkspaceRole.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

/// workspace role for the user.
public enum WorkspaceRole: String, Decodable {
    case user = "workspace_user"
    case developer = "workspace_developer"
    case admin = "workspace_admin"
    case billing = "workspace_billing"
}
