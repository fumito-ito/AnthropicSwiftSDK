//
//  BatchListResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// https://docs.anthropic.com/en/api/listing-message-batches
struct BatchListResponse {
    let data: [BatchResponse]
    let hasMore: Bool
    let firstId: String?
    let lastId: String?
}
