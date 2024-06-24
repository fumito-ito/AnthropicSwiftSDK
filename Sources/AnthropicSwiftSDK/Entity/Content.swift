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

    /// The type of content block.
    var contentType: ContentType {
        switch self {
        case .text:
            return ContentType.text
        case .image:
            return ContentType.image
        }
    }
}

extension Content: Encodable {
    enum CodingKeys: String, CodingKey {
        case text
        case type
        case source
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .text(text):
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(text, forKey: .text)
        case let .image(image):
            try container.encode(self.contentType.rawValue, forKey: .type)
            try container.encode(image, forKey: .source)
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
            fatalError("Unknown content type detected")
        case .none:
            throw ClientError.failedToParseContentType(contentTypeString)
        }
    }
}
