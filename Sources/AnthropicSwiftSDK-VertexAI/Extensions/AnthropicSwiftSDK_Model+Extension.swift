//
//  AnthropicSwiftSDK_Model+Extension.swift
//  
//
//  Created by 伊藤史 on 2024/03/28.
//

import Foundation
import AnthropicSwiftSDK

extension AnthropicSwiftSDK.Model {
    /// see https://cloud.google.com/vertex-ai/generative-ai/docs/partner-models/use-claude#use_claude_models
    var vertexAIModelName: String {
        get throws {
            switch self {
            case .claude_3_Opus:
                return "claude-3-opus@20240229"
            case .claude_3_Sonnet:
                return "claude-3-sonnet@20240229"
            case .claude_3_Haiku:
                return "claude-3-haiku@20240307"
            case .claude_3_5_Sonnet:
                return "claude-3-5-sonnet@20240620"
            case let .custom(modelName):
                return modelName
            }
        }
    }
}
