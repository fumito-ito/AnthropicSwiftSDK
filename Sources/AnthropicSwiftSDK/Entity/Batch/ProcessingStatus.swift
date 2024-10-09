//
//  ProcessingStatus.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// https://docs.anthropic.com/en/api/retrieving-message-batches
enum ProcessingStatus: String, RawRepresentable, Decodable {
    case inProgress = "in_progress"
    case canceling
    case ended
}
