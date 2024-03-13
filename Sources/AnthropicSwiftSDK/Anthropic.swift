//
//  Anthropic.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Anthropic Swift SDK root
public final class Anthropic {
    /// Messages API Interface
    public let messages: Messages
    
    /// Construction of SDK
    /// - Parameter apiKey: API key to access Anthropic API.
    public init(apiKey: String) {
        self.messages = Messages(apiKey: apiKey, session: .shared)
    }
}
