//
//  BatchResultResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

public struct BatchResult: Decodable {
    public let type: BatchResultType
    public let message: MessagesResponse?
    public let error: StreamingError?
}

/// The results will be in .jsonl format, where each line is a valid JSON object representing the result of a single request in the Message Batch.
///
/// For each streamed result, you can do something different depending on its custom_id and result type.
public struct BatchResultResponse: Decodable {
    /// ID of the request.
    public let customId: String
    /// Result of the request.
    public let result: BatchResult?
}
