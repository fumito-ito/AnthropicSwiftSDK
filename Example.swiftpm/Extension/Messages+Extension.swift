//
//  Messages+Extension.swift
//
//
//  Created by Fumito Ito on 2024/07/04.
//

import Foundation
import AnthropicSwiftSDK

extension AnthropicSwiftSDK.Messages: MessageSendable {}
extension AnthropicSwiftSDK.Messages: MessageStreamable {}
extension AnthropicSwiftSDK.MessageBatches: MessageBatchSendable {}
