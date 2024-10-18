//
//  MessageBatch.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

public struct MessageBatch {
    public let customId: String
    public let parameter: BatchParameter
    
    public init(customId: String, parameter: BatchParameter) {
        self.customId = customId
        self.parameter = parameter
    }
}
