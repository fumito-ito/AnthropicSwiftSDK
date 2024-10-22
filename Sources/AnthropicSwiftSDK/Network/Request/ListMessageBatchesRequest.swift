//
//  ListMessageBatchesRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

struct ListMessageBatchesRequest: Request {
    let method: HttpMethod = .get
    let path: String = RequestType.batches.basePath
    let queries: [String: CustomStringConvertible]?
    let body: Never? = nil

    enum Parameter: String {
        case beforeId = "before_id"
        case afterId = "after_id"
        case limit
    }
}
