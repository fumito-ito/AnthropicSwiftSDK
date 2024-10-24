//
//  RetrieveMessageBatchesRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

/// This endpoint is idempotent and can be used to poll for Message Batch completion.
/// To access the results of a Message Batch, make a request to the results_url field in the response.
struct RetrieveMessageBatchesRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.batches.basePath)/\(batchId)"
    }
    let queries: [String: CustomStringConvertible]? = nil
    let body: Never? = nil

    /// ID of the Message Batch.
    let batchId: String
}
