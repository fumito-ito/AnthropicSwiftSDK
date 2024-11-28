//
//  OrganizationMemberListResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

public struct OrganizationMemberListResponse {
    /// List of organization members
    public let data: [OrganizationMemberResponse]
    /// Indicates if there are more results in the requested page direction.
    public let hasMore: Bool
    /// First ID in the data list. Can be used as the before_id for the previous page.
    public let firstId: String?
    /// Last ID in the data list. Can be used as the after_id for the next page.
    public let lastId: String?
}
