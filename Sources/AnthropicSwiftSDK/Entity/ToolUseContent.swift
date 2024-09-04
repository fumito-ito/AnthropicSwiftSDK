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
    public let input: [String: Any]

    var inputForEncode: [String: String] {
        get throws {
            if let object = input as? [String: String] {
                return object
            }

            throw ClientError.failedToMakeEncodableToolUseInput(input)
        }
    }
}

extension ToolUseContent: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKeys.self)
        let dictionary = try container.decode([String: Any].self)

        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let input = dictionary["input"] as? [String: Any] else {
            throw ClientError.failedToDecodeToolUseContent
        }

        self.id = id
        self.name = name
        self.input = input
    }
}
