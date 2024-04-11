//
//  AnthropicVertex.swift
//  
//
//  Created by 伊藤史 on 2024/03/26.
//

import Foundation
import AnthropicSwiftSDK

/// A class for accessing the Anthropic API on Vertex AI.
public final class AnthropicVertexAIClient {
    /// Endpoint for Messages API
    public let messages: Messages

    /// Constructor for client
    ///
    /// - Parameters:
    ///   - projectId: Your project id of VertexAI
    ///   - accessToken: Your access tokens for Google Cloud
    ///   - region: VertexAI instance location. Default is `.usCentral1`
    public init(projectId: String, accessToken: String, region: SupportedRegion = .usCentral1) {
        self.messages = Messages(projectId: projectId, accessToken: accessToken, region: region)
    }
}
