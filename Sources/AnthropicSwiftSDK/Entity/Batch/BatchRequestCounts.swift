//
//  BatchRequestCounts.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// Tallies requests within the Message Batch, categorized by their status.
public struct BatchRequestCounts: Decodable {
    /// Number of requests in the Message Batch that are processing.
    let processing: Int
    /// Number of requests in the Message Batch that have completed successfully.
    ///
    /// This is zero until processing of the entire Message Batch has ended.
    let succeeded: Int
    /// Number of requests in the Message Batch that encountered an error.
    ///
    /// This is zero until processing of the entire Message Batch has ended.
    let errored: Int
    /// Number of requests in the Message Batch that have been canceled.
    ///
    /// This is zero until processing of the entire Message Batch has ended.
    let canceled: Int
    /// Number of requests in the Message Batch that have expired.
    ///
    /// This is zero until processing of the entire Message Batch has ended.
    let expired: Int
}
