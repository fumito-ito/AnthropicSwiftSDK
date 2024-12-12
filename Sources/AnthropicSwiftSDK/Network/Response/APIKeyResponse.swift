//
//  APIKeyResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

/// Object type for API Keys, this is always "api_key".
public enum APIKeyType: String, Decodable {
    case apiKey = "api_key"
}

/// The ID and type of the actor that created the API key.
public struct APIKeyActor: Decodable {
    /// ID of the actor that created the object.
    public let id: String
    /// Type of the actor that created the object.
    public let type: String
}

/// Status of the API key.
public enum APIKeyStatus: String, Codable {
    case active
    case inactive
    case archived
}

public struct APIKeyResponse: Decodable {
    /// ID of the API key.
    public let id: String
    /// Object type for API Keys, this is always "api_key".
    public let type: APIKeyType
    /// Name of the API key.
    public let name: String
    /// ID of the Workspace associated with the API key, or null if the API key belongs to the default Workspace.
    public let workspaceId: String?
    /// RFC 3339 datetime string indicating when the API Key was created.
    public let createdAt: String
    /// The ID and type of the actor that created the API key.
    public let createdBy: APIKeyActor
    /// Partially redacted hint for the API key.
    public let partialKeyHint: String?
    /// Status of the API key.
    public let status: APIKeyStatus
}
