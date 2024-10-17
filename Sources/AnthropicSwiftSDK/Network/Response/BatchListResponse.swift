//
//  BatchListResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// https://docs.anthropic.com/en/api/listing-message-batches
struct BatchListResponse {
    /// List of `BatchResponse` object.
    let data: [BatchResponse]
    /// Indicates if there are more results in the requested page direction.
    let hasMore: Bool
    /// First ID in the `data` list. Can be used as the `before_id` for the previous page.
    let firstId: String?
    /// Last ID in the `data` list. Can be used as the `after_id` for the next page.
    let lastId: String?
}
