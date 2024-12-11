//
//  UpdateWorkspaceMemberRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct UpdateWorkspaceMemberRequest: Request {
    typealias Body = WorkspaceMemberRequestBody

    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.workspaceMember(workspaceId: workspaceId).basePath)/\(userId)"
    }
    let queries: [String: any CustomStringConvertible]? = nil

    let body: WorkspaceMemberRequestBody?
    let userId: String
    let workspaceId: String
}

struct WorkspaceMemberRequestBody: Encodable {
    let role: WorkspaceRole
}
