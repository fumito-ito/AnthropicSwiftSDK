//
//  AnthropicVertexAIClient.swift
//  
//
//  Created by 伊藤史 on 2024/03/26.
//

import Foundation
import AnthropicSwiftSDK

public final class AnthropicVertexAIClient {
    let messages: Messages

    public init(apiKey: String, projectId: String, region: SupportedRegion = .usCentral1) {
        self.messages = Messages(apiKey: apiKey, projectId: projectId, region: region)
    }
}
