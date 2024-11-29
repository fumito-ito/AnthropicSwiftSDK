//
//  CreateWorkspaceMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct CreateWorkspaceMemberRequest: Request {
    typealias Body = Registration

    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.workspace.basePath)/\(workspaceId)/members"
    }
    let queries: [String : any CustomStringConvertible]? = nil

    let body: Registration?
    let workspaceId: String
}
