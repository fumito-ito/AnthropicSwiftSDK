//
//  DocumentContent.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/05.
//
import Foundation

public struct DocumentContent: Sendable {
    public enum DocumentContentType: String, Codable, Sendable {
        case base64
    }

    public enum DocumentContentMediaType: String, Codable, Sendable {
        case pdf = "application/pdf"
    }

    public let type: DocumentContentType
    public let mediaType: DocumentContentMediaType
    public let data: Data

    public init(type: DocumentContentType, mediaType: DocumentContentMediaType, data: Data) {
        self.type = type
        self.mediaType = mediaType
        self.data = data
    }
}

extension DocumentContent: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case mediaType = "media_type"
        case data
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(DocumentContent.DocumentContentType.self, forKey: .type)
        self.mediaType = try container.decode(DocumentContent.DocumentContentMediaType.self, forKey: .mediaType)
        self.data = try container.decode(Data.self, forKey: .data)
    }
}
