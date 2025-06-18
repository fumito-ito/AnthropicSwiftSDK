//
//  TokenUsage.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Billing and rate-limit usage.
public struct TokenUsage: Decodable, Sendable {
    /// The number of input tokens which were used.
    public let inputTokens: Int?
    /// The number of output tokens which were used.
    public let outputTokens: Int?

    public init(inputTokens: Int?, outputTokens: Int?) {
        self.inputTokens = inputTokens
        self.outputTokens = outputTokens
    }
}
