//
//  ProcessingStatus.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// Processing status of the Message Batch.
public enum ProcessingStatus: String, RawRepresentable, Decodable {
    case inProgress = "in_progress"
    case canceling
    case ended
}
