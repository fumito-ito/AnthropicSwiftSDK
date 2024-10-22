//
//  BatchParameter.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

import FunctionCalling

public struct BatchParameter {
    public let messages: [Message]
    public let model: Model
    public let system: [SystemPrompt]
    public let maxTokens: Int
    public let metaData: MetaData?
    public let stopSequence: [String]?
    /// Whether the response should be handles as streaming or not,
    ///
    /// This parameter is always `false`
    ///
    /// - Note: Streaming is not supported for batch requests.
    /// For more details, see https://docs.anthropic.com/en/docs/build-with-claude/message-batches#can-i-use-the-message-batches-api-with-other-api-features
    public let stream: Bool = false
    public let temperature: Double?
    public let topP: Double?
    public let topK: Int?
    public let toolContainer: ToolContainer?
    public let toolChoice: ToolChoice

    public init(
        messages: [Message],
        model: Model = .claude_3_Opus,
        system: [SystemPrompt] = [],
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequence: [String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        toolContainer: ToolContainer? = nil,
        toolChoice: ToolChoice = .auto
    ) {
        self.messages = messages
        self.model = model
        self.system = system
        self.maxTokens = maxTokens
        self.metaData = metaData
        self.stopSequence = stopSequence
        self.temperature = temperature
        self.topP = topP
        self.topK = topK
        self.toolContainer = toolContainer
        self.toolChoice = toolChoice
    }
}
