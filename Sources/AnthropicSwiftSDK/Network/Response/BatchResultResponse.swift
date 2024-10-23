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

public struct BatchResultResponse: Decodable {
    public let customId: String
    public let result: BatchResult?
}
