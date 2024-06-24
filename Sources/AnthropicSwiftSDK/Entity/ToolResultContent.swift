//
//  ToolResultContent.swift
//
//
//  Created by 伊藤史 on 2024/06/20.
//

import Foundation

public struct ToolResultContent {
    /// The `id of the tool use request this is a result for
    public let toolUseId: String
    /// The result of the tool, as a string (e.g. `"content": "15 degrees"` ) or
    /// list of nested content blocks (e.g. `"content": [{"type": "text", "text": "15 degrees"}]`).
    /// These content blocks can use the text or image types.
    public let content: [Content]
    /// Set to `true` if the tool execution resulted in an error.
    public let isError: Bool?
}

extension ToolResultContent: Encodable {}
