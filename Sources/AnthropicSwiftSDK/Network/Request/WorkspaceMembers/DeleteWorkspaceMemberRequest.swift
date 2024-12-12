//
//  DeleteWorkspaceMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct DeleteWorkspaceMemberRequest: Request {
    let method: HttpMethod = .delete
    var path: String {
        "\(RequestType.workspaceMember(workspaceId: workspaceId).basePath)/\(userId)"
    }
    let queries: [String: any CustomStringConvertible]? = nil
    let body: Never? = nil

    let userId: String
    let workspaceId: String
}
