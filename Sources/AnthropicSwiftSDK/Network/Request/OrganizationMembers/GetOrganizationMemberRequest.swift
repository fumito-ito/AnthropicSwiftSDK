//
//  GetOrganizationMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

/// https://docs.anthropic.com/en/api/admin-api/users/get-user
struct GetOrganizationMemberRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.organizationMember.basePath)/\(userId)"
    }
    let queries: [String: CustomStringConvertible]? = nil
    let body: Never? = nil

    /// ID of the User.
    let userId: String
}
