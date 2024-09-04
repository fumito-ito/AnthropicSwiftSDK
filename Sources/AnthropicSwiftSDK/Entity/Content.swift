//
//  Content.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Type of content block.
enum ContentType: String {
    /// single string
    case text
    /// image content
    case image
    /// tool use information
    case toolUse = "tool_use"
    /// result of tool use
    case toolResult = "tool_result"
}

/// The content of message.
///
/// Each input message `content` may be either a single `string` or an array of content blocks, where each block has a specific `type`. Using a `string` for `content` is shorthand for an array of one content block of type `text`.
///
/// Starting with Claude 3 models, you can also send `image` content blocks.
public enum Content {
    /// a single string
    case text(String)
    /// currently supported the `base64` source type for images, and the `image/jpeg`, `image/png`, `image/gif`, and `image/webp` media types.
    case image(ImageContent)
    case toolUse(ToolUseContent)
    case toolResult(ToolResultContent)

    /// The type of content block.
    var contentType: ContentType {
        switch self {
        case .text:
            return ContentType.text
        case .image:
            return ContentType.image
        case .toolUse:
            return ContentType.toolUse
        case .toolResult:
            return ContentType.toolResult
        }
    }
}

extension Content: Encodable {
    enum CodingKeys: String, CodingKey {
        case text
        case type
        case source
    }

    enum ToolUseCodingKeys: String, CodingKey {
        case type
        case id
        case name
        case input
    }

    enum ToolUseResultCodingKeys: String, CodingKey {
        case type
        case toolUseId = "tool_use_id"
        case content
        case isError = "is_error"
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .text(text):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(text, forKey: .text)
        case let .image(image):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(image, forKey: .source)
        case let .toolUse(toolUse):
            var container = encoder.container(keyedBy: ToolUseCodingKeys.self)
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(toolUse.id, forKey: .id)
            try container.encode(toolUse.name, forKey: .name)
            try container.encode(toolUse.inputForEncode, forKey: .input)
        case let .toolResult(toolResult):
            var container = encoder.container(keyedBy: ToolUseResultCodingKeys.self)
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(toolResult.toolUseId, forKey: .toolUseId)
            try container.encode(toolResult.content, forKey: .content)
            if toolResult.isError != nil {
                try container.encode(toolResult.isError, forKey: .isError)
            }
        }
    }
}

extension Content: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let contentTypeString = try container.decode(String.self, forKey: .type)
        let type = ContentType(rawValue: contentTypeString)

        switch type {
        case .text:
            let text = try container.decode(String.self, forKey: .text)
            self = .text(text)
        case .image:
            let image = try container.decode(ImageContent.self, forKey: .source)
            self = .image(image)
        case .toolUse:
            let content = try ToolUseContent(from: decoder)
            self = .toolUse(content)
        case .toolResult:
            fatalError("ContentType: `tool_result` is only used by user, not by assistant")
        case .none:
            throw ClientError.failedToParseContentType(contentTypeString)
        }
    }
}
