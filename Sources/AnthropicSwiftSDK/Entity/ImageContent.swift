//
//  ImageContent.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Object for image content.
public struct ImageContent {
    /// currently support the base64 source type for images
    public enum ImageContentType: String, Codable {
        case base64
    }

    /// currently support the image/jpeg, image/png, image/gif, and image/webp media types.
    public enum ImageContentMediaType: String, Codable {
        case jpeg = "image/jpeg"
        case png = "image/png"
        case gif = "image/gif"
        case webp = "image/webp"
    }

    /// Currently support the base64 source type for images
    public var type: ImageContentType
    /// Currently support the image/jpeg, image/png, image/gif, and image/webp media types.
    public var mediaType: ImageContentMediaType
    /// Base64 encoded data for image
    public var data: Data

    public init(
        type: ImageContentType = .base64,
        mediaType: ImageContentMediaType,
        data: Data
    ) {
        self.type = type
        self.mediaType = mediaType
        self.data = data
    }
}

extension ImageContent: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case mediaType = "media_type"
        case data
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(ImageContentType.self, forKey: .type)
        self.mediaType = try container.decode(ImageContentMediaType.self, forKey: .mediaType)
        self.data = try container.decode(String.self, forKey: .data).data(using: .utf8) ?? Data()
    }
}
