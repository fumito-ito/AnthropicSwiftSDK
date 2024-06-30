//
//  UnnecessaryParameter.swift
//
//
//  Created by 伊藤史 on 2024/07/01.
//

import Foundation

/// Unnecessary parameters to use Anthropic claude through AWS Bedrock
///
/// When using the Anthropic API through AWS Bedrock, some of the properties required in a normal Anthropic API request were causing errors as invalid properties.
enum UnnecessaryParameter: String, CaseIterable {
    case model
    case stream
    case metadata
}
