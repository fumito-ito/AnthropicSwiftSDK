//
//  MessagesRequest.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Request object for Messages API
///
/// a structured list of input messages with text and/or image content, and the model will generate the next message in the conversation.
struct MessagesRequest: Encodable {
    /// The model that will complete your prompt.
    let model: Model
    /// Input messages.
    let messages: [Message]
    /// System prompt.
    ///
    /// A system prompt is a way of providing context and instructions to Claude, such as specifying a particular goal or role.
    let system: String?
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
    let topP: Int?
    /// Only sample from the top K options for each subsequent token.
    ///
    /// Used to remove "long tail" low probability responses.
    /// Recommended for advanced use cases only. You usually only need to use temperature.
    let topK: Int?

    init(
        model: Model = .claude_3_Opus,
        messages: [Message],
        system: String? = nil,
        maxTokens: Int,
        metaData: MetaData? = nil,
        stopSequences: [String]? = nil,
        stream: Bool = false,
        temperature: Double? = nil,
        topP: Int? = nil,
        topK: Int? = nil
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
    }
}
