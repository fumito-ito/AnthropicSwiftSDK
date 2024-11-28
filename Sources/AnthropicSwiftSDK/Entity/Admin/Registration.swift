//
//  Registration.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

public struct Registration {
    /// ID of the User.
    public let userId: String
    /// Role of the new Workspace Member. Cannot be "workspace_billing".
    public let workspaceRole: WorkspaceRole
}
