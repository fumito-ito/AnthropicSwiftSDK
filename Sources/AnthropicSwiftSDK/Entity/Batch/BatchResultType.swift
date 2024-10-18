//
//  BatchResultType.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// https://docs.anthropic.com/en/docs/build-with-claude/message-batches#retrieving-batch-results
public enum BatchResultType: Decodable {
    case succeeded // include the message result as jsonl
    case errored
    case cancelled
    case expired
}
