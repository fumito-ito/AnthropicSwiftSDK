//
//  ObjectListResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/28.
//

public struct ObjectListResponse<Object: Decodable>: Decodable {
    public let data: [Object]
    public let hasMore: Bool
    public let firstId: String?
    public let lastId: String?
}
