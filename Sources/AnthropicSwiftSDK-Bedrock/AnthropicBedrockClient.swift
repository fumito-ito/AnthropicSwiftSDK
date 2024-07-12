//
//  AnthropicBedrockClient.swift
//
//
//  Created by 伊藤史 on 2024/03/22.
//

import Foundation
import AWSBedrockRuntime
import AnthropicSwiftSDK

/// Claude API Client through Bedrock API
public final class AnthropicBedrockClient {
    /// Endpoint for Messages API
    public let messages: AnthropicSwiftSDK_Bedrock.Messages

    public static var anthropicVersion: String {
        AnthropicVersion.custom("bedrock-2023-05-31").stringfy
    }

    init(client: BedrockRuntimeClient) {
        self.messages = .init(client: client)
    }
}
