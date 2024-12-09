//
//  WorkspaceResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

/// Object type for Workspaces, this is always "workspace".
public enum WorkspaceType: String, Decodable {
    case workspace
}

public struct WorkspaceResponse: Decodable {
    /// ID of the Workspace.
    public let id: String
    /// Object type for Workspaces, this is always "workspace".
    public let type: WorkspaceType
    /// Name of the Workspace.
    public let name: String
    /// RFC 3339 datetime string indicating when the Workspace was created.
    public let createdAt: String
    /// RFC 3339 datetime string indicating when the Workspace was archived, or null if the Workspace is not archived.
    public let archivedAt: String?
    /// Hex color code representing the Workspace in the Anthropic Console.
    public let displayColor: String
}
