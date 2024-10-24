//
//  CancelMessageBatchRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

/// Batches may be canceled any time before processing ends.
///
/// Once cancellation is initiated, the batch enters a canceling state, at which time the system may complete any in-progress, non-interruptible requests before finalizing cancellation.
/// The number of canceled requests is specified in request_counts. To determine which requests were canceled, check the individual results within the batch. Note that cancellation may not result in any canceled requests if they were non-interruptible.
struct CancelMessageBatchRequest: Request {
    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.batches.basePath)/\(batchId)/cancel"
    }
    let queries: [String: CustomStringConvertible]? = nil
    let body: Never? = nil
    /// ID of the Message Batch.
    let batchId: String
}
