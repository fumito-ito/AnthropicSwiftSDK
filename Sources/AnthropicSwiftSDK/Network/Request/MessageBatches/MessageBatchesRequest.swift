//
//  MessageBatchesRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// The Message Batches API can be used to process multiple Messages API requests at once.
///
/// Once a Message Batch is created, it begins processing immediately.
/// Batches can take up to 24 hours to complete.
///
/// The Message Batches API supports the following models: Claude 3 Haiku, Claude 3 Opus, and Claude 3.5 Sonnet.
/// All features available in the Messages API, including beta features, are available through the Message Batches API.
/// While in beta, batches may contain up to 10,000 requests and be up to 32 MB in total size.
struct MessageBatchesRequest: Request {
    typealias Body = MessageBatchesRequestBody

    let method: HttpMethod = .post
    let path: String = RequestType.batches.basePath
    let queries: [String: CustomStringConvertible]? = nil
    let body: MessageBatchesRequestBody?
}

// MARK: Request Body

struct MessageBatchesRequestBody: Encodable {
    /// List of requests for prompt completion. Each is an individual request to create a Message.
    let requests: [Batch]

    init(from batches: [MessageBatch]) {
        self.requests = batches.map { Batch(from: $0) }
    }
}

struct Batch: Encodable {
    /// Developer-provided ID created for each request in a Message Batch. Useful for matching results to requests, as results may be given out of request order.
    ///
    /// Must be unique for each request within the Message Batch.
    let customId: String
    /// Messages API creation parameters for the individual request.
    ///
    /// See the [Messages API reference](https://docs.anthropic.com/en/api/messages) for full documentation on available parameters.
    let params: MessagesRequestBody

    init(from batch: MessageBatch) {
        self.customId = batch.customId
        self.params = MessagesRequestBody(from: batch.parameter)
    }
}
