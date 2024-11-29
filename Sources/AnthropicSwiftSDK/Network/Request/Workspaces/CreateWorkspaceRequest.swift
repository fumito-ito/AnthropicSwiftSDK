//
//  CreateWorkspaceRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct CreateWorkspaceRequest: Request {
    typealias Body = WorkspaceRequestBody

    let method: HttpMethod = .post
    let path: String = RequestType.workspace.basePath
    let queries: [String : any CustomStringConvertible]? = nil

    let body: WorkspaceRequestBody?
}
