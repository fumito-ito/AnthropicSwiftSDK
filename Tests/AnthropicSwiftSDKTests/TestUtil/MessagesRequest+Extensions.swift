//
//  MessagesRequest+Extensions.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation
@testable import AnthropicSwiftSDK

extension MessagesRequest {
    static var nop: Self {
        MessagesRequest(messages: [], maxTokens: 1024)
    }
}
