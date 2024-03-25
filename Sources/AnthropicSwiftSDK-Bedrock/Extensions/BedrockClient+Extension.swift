//
//  BedrockClient+Extension.swift
//
//
//  Created by 伊藤史 on 2024/03/22.
//

import Foundation
import AWSBedrockRuntime
import AnthropicSwiftSDK

public extension BedrockRuntimeClient {
    /// Create a client using Claude through Bedrock
    /// - Parameters:
    ///   - client: Bedrock runtime client
    ///   - model: Claude model, Bedrock supports Haiku or Sonnet instance type.
    /// - Returns: Client using Claude through Bedrock
    static func useAnthropic(_ client: BedrockRuntimeClient, model: Model) -> AnthropicBedrockClient {
        AnthropicBedrockClient(client: client, model: model)
    }
}
