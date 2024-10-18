//
//  BatchResponse.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// https://docs.anthropic.com/en/api/creating-message-batches
public struct BatchResponse: Decodable {
    /// Unique object identifier.
    ///
    /// The format and length of IDs may change over time.
    public let id: String
    /// Object type.
    ///
    /// For Message Batches, this is always "message_batch".
    public let type: BatchType
    /// Processing status of the Message Batch.
    public let processingStatus: ProcessingStatus
    /// Tallies requests within the Message Batch, categorized by their status.
    ///
    /// Requests start as processing and move to one of the other statuses only once processing of the entire batch ends. The sum of all values always matches the total number of requests in the batch.
    public let requestCounts: BatchRequestCounts
    /// RFC 3339 datetime string representing the time at which processing for the Message Batch ended. Specified only once processing ends.
    ///
    /// Processing ends when every request in a Message Batch has either succeeded, errored, canceled, or expired.
    public let endedAt: String?
    /// RFC 3339 datetime string representing the time at which the Message Batch was created.
    public let createdAt: String
    /// RFC 3339 datetime string representing the time at which the Message Batch will expire and end processing, which is 24 hours after creation.
    public let expiresAt: String
    /// RFC 3339 datetime string representing the time at which cancellation was initiated for the Message Batch. Specified only if cancellation was initiated.
    public let cancelInitiatedAt: String?
    /// URL to a .jsonl file containing the results of the Message Batch requests. Specified only once processing ends.
    ///
    /// Results in the file are not guaranteed to be in the same order as requests. Use the custom_id field to match results to requests.
    public let resultsURL: String?
}
