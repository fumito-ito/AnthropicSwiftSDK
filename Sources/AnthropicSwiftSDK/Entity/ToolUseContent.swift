//
//  ToolUseContent.swift
//
//
//  Created by 伊藤史 on 2024/06/20.
//

import Foundation

public struct ToolUseContent {
    /// A unique identifier for this particular tool use block.
    /// This will be used to match up the tool results later.
    public let id: String
    /// The name of the tool being used.
    public let name: String
    /// An object containing the input being passed to the tool, conforming to the tool’s `input_schema`.
    public let input: [String: String]
}

extension ToolUseContent: Decodable {}
