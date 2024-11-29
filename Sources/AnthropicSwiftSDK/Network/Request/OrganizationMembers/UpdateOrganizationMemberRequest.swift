//
//  UpdateOrganizationMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct UpdateOrganizationMemberRequest: Request {
    typealias Body = OrganizationRole

    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.organizationMember)/\(userId)"
    }
    let queries: [String : any CustomStringConvertible]? = nil

    let body: OrganizationRole?
    let userId: String
}
