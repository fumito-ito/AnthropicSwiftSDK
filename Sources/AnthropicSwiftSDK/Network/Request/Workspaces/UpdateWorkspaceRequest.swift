//
//  UpdateWorkspaceRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct UpdateWorkspaceRequest: Request {
    typealias Body = WorkspaceRequestBody

    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.workspace.basePath)/\(workspaceId)"
    }
    let queries: [String : any CustomStringConvertible]? = nil

    let body: WorkspaceRequestBody?
    let workspaceId: String
}

struct WorkspaceRequestBody: Encodable {
    let name: String
}
