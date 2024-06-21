//
//  AnthropicSwiftSDK_Model+Extension.swift
//
//
//  Created by 伊藤史 on 2024/03/23.
//

import Foundation
import AnthropicSwiftSDK

extension AnthropicSwiftSDK.Model {
    /// Model name for Amazon Bedrock
    ///
    /// for more detail, see https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html
    var bedrockModelName: String? {
        switch self {
        case .claude_3_Opus:
            return nil
        case .claude_3_Sonnet:
            return "anthropic.claude-3-sonnet-20240229-v1:0"
        case .claude_3_Haiku:
            return "anthropic.claude-3-haiku-20240307-v1:0"
        case .claude_3_5_Sonnet:
            return "anthropic.claude-3-5-sonnet-20240620-v1:0"
        case let .custom(modelName):
            return modelName
        }
    }
}
