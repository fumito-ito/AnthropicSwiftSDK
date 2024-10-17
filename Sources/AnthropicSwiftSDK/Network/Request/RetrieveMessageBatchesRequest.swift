//
//  RetrieveMessageBatchesRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

struct RetrieveMessageBatchesRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.batches.basePath)/\(batchId)"
    }
    let queries: [String: CustomStringConvertible]? = nil
    let body: Never? = nil

    let batchId: String
}
