//
//  SystemPrompt.swift
//
//
//  Created by 伊藤史 on 2024/09/04.
//

import Foundation

public enum CacheControl {
    /// corresponds to this 5-minute lifetime.
    case ephemeral
}

public enum SystemPrompt {
    case text(String, CacheControl?)
}
