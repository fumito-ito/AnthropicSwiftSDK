//
//  UpdateOrganizationMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct UpdateOrganizationMemberRequest: Request {
    typealias Body = OrganizationMememberRequestBody

    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.organizationMember.basePath)/\(userId)"
    }
    let queries: [String: any CustomStringConvertible]? = nil

    let body: OrganizationMememberRequestBody?
    let userId: String
}

struct OrganizationMememberRequestBody: Encodable {
    let role: OrganizationRole
}
