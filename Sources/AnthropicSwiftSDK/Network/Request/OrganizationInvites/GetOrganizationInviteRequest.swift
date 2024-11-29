//
//  GetOrganizationInviteRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct GetOrganizationInviteRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.organizationInvite.basePath)/\(invitationId)"
    }
    let queries: [String : any CustomStringConvertible]? = nil
    let body: Never? = nil

    let invitationId: String
}
