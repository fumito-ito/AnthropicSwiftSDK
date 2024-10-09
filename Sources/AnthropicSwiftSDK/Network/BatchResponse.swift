//
//  BatchResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// https://docs.anthropic.com/en/api/creating-message-batches
struct BatchResponse: Decodable {
    let id: String
    let type: BatchType
    let processingStatus: ProcessingStatus
    let requestCounts: BatchRequestCounts
    let endedAt: String
    let createdAt: String
    let expiresAt: String
    let cancelInitiatedAt: String?
    let resultsURL: String?
}
