//
//  GetWorkspaceMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct GetWorkspaceMemberRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.workspaceMember(workspaceId: workspaceId).basePath)/\(userId)"
    }
    let queries: [String: any CustomStringConvertible]? = nil
    let body: Never? = nil

    let workspaceId: String
    let userId: String
}
