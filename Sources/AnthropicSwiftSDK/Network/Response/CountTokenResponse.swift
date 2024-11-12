//
//  CountTokenResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/13.
//

/// Billing and rate-limit usage.
public struct CountTokenResponse: Decodable {
    /// The number of input tokens which were used.
    public let inputTokens: Int?
}
