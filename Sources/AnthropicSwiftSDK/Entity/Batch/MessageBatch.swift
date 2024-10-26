//
//  MessageBatch.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

public struct MessageBatch {
    /// Developer-provided ID created for each request in a Message Batch. Useful for matching results to requests, as results may be given out of request order.
    ///
    /// Must be unique for each request within the Message Batch.
    public let customId: String
    /// Messages API creation parameters for the individual request.
    ///
    /// See the [Messages API](https://docs.anthropic.com/en/api/messages) reference for full documentation on available parameters.
    public let parameter: BatchParameter

    public init(customId: String, parameter: BatchParameter) {
        self.customId = customId
        self.parameter = parameter
    }
}
