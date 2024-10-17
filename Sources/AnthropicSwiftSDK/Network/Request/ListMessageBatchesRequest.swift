//
//  ListMessageBatchesRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

struct ListMessageBatchesRequest: Request {
    let method: HttpMethod = .get
    let path: String = RequestType.batches.basePath
    let queries: [String: CustomStringConvertible]? = nil
    let body: Never? = nil
}
