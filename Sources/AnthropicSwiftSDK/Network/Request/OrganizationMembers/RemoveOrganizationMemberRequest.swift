//
//  RemoveOrganizationMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct RemoveOrganizationMemberRequest: Request {
    let method: HttpMethod = .delete
    var path: String {
        "\(RequestType.organizationMember.basePath)/\(userId)"
    }
    let queries: [String : any CustomStringConvertible]? = nil
    let body: Never? = nil

    let userId: String
}
