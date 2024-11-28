//
//  WorkspaceListResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

public struct WorkspaceListResponse {
    /// List of workspaces
    public let data: [WorkspaceResponse]
    /// Indicates if there are more results in the requested page direction.
    public let hasMore: Bool
    /// First ID in the data list. Can be used as the before_id for the previous page.
    public let firstId: String?
    /// Last ID in the data list. Can be used as the after_id for the next page.
    public let afterId: String?
}
