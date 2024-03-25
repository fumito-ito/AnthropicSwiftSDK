//
//  AnthropicBedrockClient.swift
//
//
//  Created by 伊藤史 on 2024/03/22.
//

import Foundation
import AWSBedrockRuntime
import AnthropicSwiftSDK

public final class AnthropicBedrockClient {
    public let messages: AnthropicSwiftSDK_Bedrock.Messages

    init(client: BedrockRuntimeClient, model: Model) {
        self.messages = .init(client: client, model: model)
    }
}
