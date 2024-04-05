//
//  MessagesRequest+Extensions.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation
import AnthropicSwiftSDK

extension MessagesRequest {
    public static var nop: Self {
        MessagesRequest(messages: [], maxTokens: 1024)
    }
}
