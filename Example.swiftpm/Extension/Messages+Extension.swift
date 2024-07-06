//
//  Messages+Extension.swift
//
//
//  Created by Fumito Ito on 2024/07/04.
//

import Foundation
import AnthropicSwiftSDK
import AnthropicSwiftSDK_Bedrock
import AnthropicSwiftSDK_VertexAI

extension AnthropicSwiftSDK.Messages: MessageSendable {}
extension AnthropicSwiftSDK.Messages: MessageStreamable {}
extension AnthropicSwiftSDK_Bedrock.Messages: MessageSendable {}
extension AnthropicSwiftSDK_Bedrock.Messages: MessageStreamable {}
extension AnthropicSwiftSDK_VertexAI.Messages: MessageSendable {}
extension AnthropicSwiftSDK_VertexAI.Messages: MessageStreamable {}
