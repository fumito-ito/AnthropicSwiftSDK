//
//  UnnecessaryParameter.swift
//  
//
//  Created by 伊藤史 on 2024/07/10.
//

import Foundation

/// Unnecessary parameters to use Anthropic claude through VertexAI
///
/// When using the Anthropic API through VertexAI, some of the properties required in a normal Anthropic API request were causing errors as invalid properties.
enum UnnecessaryParameter: String, CaseIterable {
    case model
}
