//
//  MessageBatchesRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

struct MessageBatchesRequest: Request {
    typealias Body = MessageBatchesRequestBody

    let method: HttpMethod = .post
    let path: String = RequestType.batches.basePath
    let queries: [String: CustomStringConvertible]? = nil
    let body: MessageBatchesRequestBody?
}

// MARK: Request Body

/// https://docs.anthropic.com/en/api/creating-message-batches
struct MessageBatchesRequestBody: Encodable {
    /// List of requests for prompt completion. Each is an individual request to create a Message.
    let requests: [Batch]
}

/// https://docs.anthropic.com/en/api/creating-message-batches
struct Batch: Encodable {
    /// Developer-provided ID created for each request in a Message Batch. Useful for matching results to requests, as results may be given out of request order.
    ///
    /// Must be unique for each request within the Message Batch.
    let customId: String
    /// Messages API creation parameters for the individual request.
    ///
    /// See the [Messages API reference](https://docs.anthropic.com/en/api/messages) for full documentation on available parameters.
    let params: MessagesRequestBody
}
