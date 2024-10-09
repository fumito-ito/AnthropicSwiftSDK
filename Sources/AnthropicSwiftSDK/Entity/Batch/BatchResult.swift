//
//  BatchResult.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// https://docs.anthropic.com/en/docs/build-with-claude/message-batches#retrieving-batch-results
enum BatchResult {
    case succeeded // include the message result as jsonl
    case errored(Error)
    case cancelled
    case expired
}
