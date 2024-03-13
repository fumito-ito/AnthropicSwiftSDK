//
//  StopReason.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// The reason that we stopped.
public enum StopReason: String, Decodable {
    /// the model reached a natural stopping point
    case endTurn = "end_turn"
    /// we exceeded the requested max_tokens or the model's maximum
    case maxTokens = "max_tokens"
    /// one of your provided custom `stop_sequences` was generated
    case stopSequence = "stop_sequence"
}
