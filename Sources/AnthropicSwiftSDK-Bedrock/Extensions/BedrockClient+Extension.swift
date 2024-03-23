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
    static func useAnthropic(_ client: BedrockRuntimeClient, model: Model) -> BedrockAnthropicClient {
        BedrockAnthropicClient(client: client, model: model)
    }
}
