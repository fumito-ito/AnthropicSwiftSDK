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
}

extension ImageContent: Codable {}
