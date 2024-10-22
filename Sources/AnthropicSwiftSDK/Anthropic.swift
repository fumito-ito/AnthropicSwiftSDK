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

    /// MessageBatches API Interface
    public let messageBatches: MessageBatches

    /// Construction of SDK
    /// - Parameter apiKey: API key to access Anthropic API.
    public init(apiKey: String) {
        self.messages = Messages(apiKey: apiKey, session: .shared)
        self.messageBatches = MessageBatches(apiKey: apiKey, session: .shared)
    }
}
