//
//  OrganizationRole.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/27.
//

public enum OrganizationRole: String, Codable {
    /// Can use Workbench
    case user
    /// Can use Workbench and manage API keys
    case developer
    /// Can use Workbench and manage billing details
    case billing
    /// Can do all of the above, plus manage users
    case admin
}
