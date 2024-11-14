//
//  Content.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Type of content block.
public enum ContentType: String {
    /// single string
    case text
    /// image content
    case image
    /// tool use information
    case toolUse = "tool_use"
    /// result of tool use
    case toolResult = "tool_result"
    /// document, like pdf
    case document
}

/// The content of message.
///
/// Each input message `content` may be either a single `string` or an array of content blocks, where each block has a specific `type`. Using a `string` for `content` is shorthand for an array of one content block of type `text`.
///
/// Starting with Claude 3 models, you can also send `image` content blocks.
public enum Content {
    /// a single string
    case text(String, cacheControl: CacheControl? = nil)
    /// currently supported the `base64` source type for images, and the `image/jpeg`, `image/png`, `image/gif`, and `image/webp` media types.
    case image(ImageContent, cacheControl: CacheControl? = nil)
    case toolUse(ToolUseContent)
    case toolResult(ToolResultContent)
    case document(DocumentContent, cacheControl: CacheControl? = nil)

    /// The type of content block.
    public var contentType: ContentType {
        switch self {
        case .text:
            return .text
        case .image:
            return .image
        case .toolUse:
            return .toolUse
        case .toolResult:
            return .toolResult
        case .document:
            return .document
        }
    }
}

extension Content: Encodable {
    enum CodingKeys: String, CodingKey {
        case type
    }

    enum TextCodingKeys: String, CodingKey {
        case type
        case text
        case cacheControl = "cache_control"
    }

    enum BinaryCodingKeys: String, CodingKey {
        case type
        case source
        case cacheControl = "cache_control"
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
        case let .text(text, cacheControl):
            var container = encoder.container(keyedBy: TextCodingKeys.self)
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(text, forKey: .text)
            if let cacheControl {
                try container.encode(cacheControl, forKey: .cacheControl)
            }
        case let .image(image, cacheControl):
            var container = encoder.container(keyedBy: BinaryCodingKeys.self)
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(image, forKey: .source)
            if let cacheControl {
                try container.encode(cacheControl, forKey: .cacheControl)
            }
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
        case let .document(document, cacheControl):
            var container = encoder.container(keyedBy: BinaryCodingKeys.self)
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(document, forKey: .source)
            if let cacheControl {
                try container.encode(cacheControl, forKey: .cacheControl)
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
            let textContainer = try decoder.container(keyedBy: TextCodingKeys.self)
            let text = try textContainer.decode(String.self, forKey: .text)
            self = .text(text)
        case .image:
            let imageContainer = try decoder.container(keyedBy: BinaryCodingKeys.self)
            let image = try imageContainer.decode(ImageContent.self, forKey: .source)
            self = .image(image)
        case .toolUse:
            let content = try ToolUseContent(from: decoder)
            self = .toolUse(content)
        case .toolResult:
            fatalError("ContentType: `tool_result` is only used by user, not by assistant")
        case .document:
            let documentContainer = try decoder.container(keyedBy: BinaryCodingKeys.self)
            let document = try documentContainer.decode(DocumentContent.self, forKey: .source)
            self = .document(document)
        case .none:
            throw ClientError.failedToParseContentType(contentTypeString)
        }
    }
}
