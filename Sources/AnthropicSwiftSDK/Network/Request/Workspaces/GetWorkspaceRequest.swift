//
//  GetWorkspaceRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct GetWorkspaceRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.workspace.basePath)/\(workspaceId)"
    }
    let queries: [String: any CustomStringConvertible]? = nil
    let body: Never? = nil

    let workspaceId: String
}
