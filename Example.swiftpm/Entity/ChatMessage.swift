//
//  ChatMessage.swift
//
//
//  Created by Fumito Ito on 2024/07/05.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let user: ChatUser
    let text: String
}
