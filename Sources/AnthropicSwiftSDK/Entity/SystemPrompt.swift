//
//  SystemPrompt.swift
//
//
//  Created by 伊藤史 on 2024/09/04.
//

import Foundation

public enum CacheControl: String {
    /// corresponds to this 5-minute lifetime.
    case ephemeral
}

extension CacheControl: Encodable {
    enum CodingKeys: CodingKey {
        case type
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .type)
    }
}

public enum SystemPrompt {
    case text(String, CacheControl?)

    private var type: String {
        switch self {
        case .text:
            return "text"
        }
    }
}

extension SystemPrompt: Encodable {
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case cacheControl = "cache_control"
    }

    public func encode(to encoder: any Encoder) throws {
        guard case let .text(text, cacheControl) = self else {
            throw ClientError.failedToEncodeSystemPrompt
        }

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(text, forKey: .text)
        if let cacheControl {
            try container.encode(cacheControl, forKey: .cacheControl)
        }
    }
}
