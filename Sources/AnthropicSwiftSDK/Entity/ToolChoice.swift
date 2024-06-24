//
//  ToolChoice.swift
//
//
//  Created by 伊藤史 on 2024/06/18.
//

import Foundation

/// In some cases, you may want Claude to use a specific tool to answer the user’s question, even if Claude thinks it can provide an answer without using a tool. You can do this by specifying the tool in the `tool_choice` field.
///
/// - Note:
/// Note that when you have `tool_choice` as `any` or `tool`, we will prefill the assistant message to force a tool to be used. This means that the models will not emit a chain-of-thought `text` content block before `tool_use` content blocks, even if explicitly asked to do so.
///
/// Our testing has shown that this should not reduce performance. If you would like to keep chain-of-thought (particularly with Opus) while still requesting that the model use a specific tool, you can use `{"type": "auto"}` for `tool_choice` (the default) and add explicit instructions in a user message. For example: `What's the weather like in London? Use the get_weather tool in your response.`
public enum ToolChoice {
    /// allows Claude to decide whether to call any provided tools or not. This is the default value.
    case auto
    /// tells Claude that it must use one of the provided tools, but doesn’t force a particular tool.
    case any
    /// allows us to force Claude to always use a particular tool.
    case tool(String)
}

extension ToolChoice {
    var type: String {
        switch self {
        case .auto:
            "auto"
        case .any:
            "any"
        case .tool:
            "tool"
        }
    }

    var toolName: String? {
        switch self {
        case .auto, .any:
            nil
        case .tool(let toolName):
            toolName
        }
    }
}

extension ToolChoice: Encodable {
    enum CodingKeys: CodingKey {
        case type
        case name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        if let toolName {
            try container.encode(toolName, forKey: .name)
        }
    }
}
