//
//  UpdateWorkspaceMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct UpdateWorkspaceMemberRequest: Request {
    typealias Body = WorkspaceRole

    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.workspaceMember(workspaceId: workspaceId).basePath)/\(userId)"
    }
    let queries: [String: any CustomStringConvertible]? = nil

    let body: WorkspaceRole?
    let userId: String
    let workspaceId: String
}
