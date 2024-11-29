//
//  ArchiveWorkspaceRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct ArchiveWorkspaceRequest: Request {
    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.workspace.basePath)/\(workspaceId)/archive"
    }
    var queries: [String: any CustomStringConvertible]?
    let body: Never? = nil

    let workspaceId: String
}
