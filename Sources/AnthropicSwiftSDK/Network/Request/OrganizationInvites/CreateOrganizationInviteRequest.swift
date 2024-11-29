//
//  CreateOrganizationInviteRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct CreateOrganizationInviteRequest: Request {
    typealias Body = Invitation

    let method: HttpMethod = .post
    let path: String = RequestType.organizationInvite.basePath
    let queries: [String : any CustomStringConvertible]? = nil

    let body: Invitation?
}
