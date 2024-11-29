//
//  DeleteOrganizationInviteRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct DeleteOrganizationInviteRequest: Request {
    let method: HttpMethod = .delete
    var path: String {
        "\(RequestType.organizationInvite.basePath)/\(invitationId)"
    }
    let queries: [String: any CustomStringConvertible]? = nil
    let body: Never? = nil

    let invitationId: String
}
