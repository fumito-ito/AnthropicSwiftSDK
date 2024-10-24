//
//  RetrieveMessageBatchResultsRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

/// Streams the results of a Message Batch as a .jsonl file.
///
/// Each line in the file is a JSON object containing the result of a single request in the Message Batch.
/// Results are not guaranteed to be in the same order as requests. Use the custom_id field to match results to requests.
///
/// While in beta, this endpoint requires passing the anthropic-beta header with value message-batches-2024-09-24
struct RetrieveMessageBatchResultsRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.batches.basePath)/\(batchId)/results"
    }
    let queries: [String: CustomStringConvertible]? = nil
    let body: Never? = nil

    /// ID of the Message Batch.
    let batchId: String
}
