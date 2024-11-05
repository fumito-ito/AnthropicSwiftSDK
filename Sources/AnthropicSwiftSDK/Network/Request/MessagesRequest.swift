//
//  MessagesRequest.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

struct MessagesRequest: Request {
    typealias Body = MessagesRequestBody

    let method: HttpMethod = .post
    let path: String = RequestType.messages.basePath
    let queries: [String: CustomStringConvertible]? = nil
    let body: Body?
}

// MARK: Request Body

/// Request object for Messages API
///
/// a structured list of input messages with text and/or image content, and the model will generate the next message in the conversation.
struct MessagesRequestBody: Encodable {
    /// The model that will complete your prompt.
    let model: Model
    /// Input messages.
    let messages: [Message]
    /// System prompt.
    ///
    /// A system prompt is a way of providing context and instructions to Claude, such as specifying a particular goal or role.
    let system: [SystemPrompt]
    /// The maximum number of tokens to generate before stopping.
    ///
    /// Note that our models may stop before reaching this maximum. This parameter only specifies the absolute maximum number of tokens to generate.
    /// Different models have different maximum values for this parameter.
    let maxTokens: Int
    /// An object describing metadata about the request.
    let metaData: MetaData?
    /// Custom text sequences that will cause the model to stop generating.
    let stopSequences: [String]?
    /// Whether to incrementally stream the response using server-sent events.
    ///
    /// see [streaming](https://docs.anthropic.com/claude/reference/messages-streaming) for more detail.
    let stream: Bool
    /// Amount of randomness injected into the response.
    ///
    /// Defaults to 1.0. Ranges from 0.0 to 1.0. Use temperature closer to 0.0 for analytical / multiple choice, and closer to 1.0 for creative and generative tasks.
    /// Note that even with temperature of 0.0, the results will not be fully deterministic.
    let temperature: Double?
    /// Use nucleus sampling.
    ///
    /// In nucleus sampling, we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and cut it off once it reaches a particular probability specified by top_p. You should either alter temperature or top_p, but not both.
    /// Recommended for advanced use cases only. You usually only need to use temperature.
    let topP: Double?
    /// Only sample from the top K options for each subsequent token.
    ///
    /// Used to remove "long tail" low probability responses.
    /// Recommended for advanced use cases only. You usually only need to use temperature.
    let topK: Int?
    /// Definition of tools with names, descriptions, and input schemas in your API request.
    let tools: [Tool]?
    /// Definition whether or not to force Claude to use the tool. ToolChoice should be set if tools are specified.
    let toolChoice: ToolChoice?

    init(
        model: Model = .claude_3_Opus,
        messages: [Message],
        system: [SystemPrompt] = [],
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequences: [String]? = nil,
        stream: Bool = false,
        temperature: Double? = nil,
        topP: Double? = nil,
        topK: Int? = nil,
        tools: [Tool]? = nil,
        toolChoice: ToolChoice = .auto
    ) {
        self.model = model
        self.messages = messages
        self.system = system
        self.maxTokens = maxTokens
        self.metaData = metaData
        self.stopSequences = stopSequences
        self.stream = stream
        self.temperature = temperature
        self.topP = topP
        self.topK = topK
        self.tools = tools
        self.toolChoice = tools == nil ? nil : toolChoice // ToolChoice should be set if tools are specified.
    }

    init(from parameter: BatchParameter) {
        self.model = parameter.model
        self.messages = parameter.messages
        self.system = parameter.system
        self.maxTokens = parameter.maxTokens
        self.metaData = parameter.metaData
        self.stopSequences = parameter.stopSequence
        self.stream = parameter.stream
        self.temperature = parameter.temperature
        self.topP = parameter.topP
        self.topK = parameter.topK
        self.tools = parameter.tools
        self.toolChoice = parameter.tools == nil ? nil : parameter.toolChoice
    }
}
