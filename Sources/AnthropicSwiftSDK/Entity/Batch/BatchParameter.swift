//
//  BatchParameter.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/18.
//

import FunctionCalling

public struct BatchParameter {
    /// Input messages.
    public let messages: [Message]
    /// The model that will complete your prompt.
    ///
    /// See [models](https://docs.anthropic.com/en/docs/models-overview) for additional details and options.
    public let model: Model
    /// System prompt.
    ///
    /// A system prompt is a way of providing context and instructions to Claude, such as specifying a particular goal or role.
    public let system: [SystemPrompt]
    /// The maximum number of tokens to generate before stopping.
    public let maxTokens: Int
    /// An object describing metadata about the request.
    public let metaData: MetaData?
    /// Custom text sequences that will cause the model to stop generating.
    public let stopSequence: [String]?
    /// Whether the response should be handles as streaming or not,
    ///
    /// This parameter is always `false`
    ///
    /// - Note: Streaming is not supported for batch requests.
    /// For more details, see https://docs.anthropic.com/en/docs/build-with-claude/message-batches#can-i-use-the-message-batches-api-with-other-api-features
    public let stream: Bool = false
    /// Amount of randomness injected into the response.
    public let temperature: Double?
    /// Use nucleus sampling.
    public let topP: Double?
    /// Only sample from the top K options for each subsequent token.
    public let topK: Int?
    /// Definitions of tools that the model may use.
    public let toolContainer: ToolContainer?
    /// How the model should use the provided tools. The model can use a specific tool, any available tool, or decide by itself.
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
