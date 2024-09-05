//
//  SystemPrompt.swift
//
//
//  Created by 伊藤史 on 2024/09/04.
//

import Foundation

public enum CacheControl: String, Encodable {
    /// corresponds to this 5-minute lifetime.
    case ephemeral
}

public enum SystemPrompt {
    case text(String, CacheControl?)
}

extension SystemPrompt: Encodable {
    enum CodingKeys: CodingKey {
        case text
        case cacheControl
    }

    public func encode(to encoder: any Encoder) throws {
        guard case let .text(text, cacheControl) = self else {
            fatalError()
        }

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(cacheControl, forKey: .cacheControl)
    }
}
