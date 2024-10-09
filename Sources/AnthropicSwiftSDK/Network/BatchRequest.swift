//
//  BatchRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

public struct Batch: Encodable {
    let customId: String
    let params: MessagesRequest
}

/// https://docs.anthropic.com/en/api/creating-message-batches
public struct BatchRequest: Encodable {
    let requests: [Batch]
}
