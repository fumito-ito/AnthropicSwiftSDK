//
//  MessagesRequest.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation
import FunctionCalling

/// Request object for Messages API
///
/// a structured list of input messages with text and/or image content, and the model will generate the next message in the conversation.
public struct MessagesRequest: Encodable {
    /// The model that will complete your prompt.
    public let model: Model
    /// Input messages.
    public let messages: [Message]
    /// System prompt.
    ///
    /// A system prompt is a way of providing context and instructions to Claude, such as specifying a particular goal or role.
    public let system: [SystemPrompt]
    /// The maximum number of tokens to generate before stopping.
    ///
    /// Note that our models may stop before reaching this maximum. This parameter only specifies the absolute maximum number of tokens to generate.
    /// Different models have different maximum values for this parameter.
    public let maxTokens: Int
    /// An object describing metadata about the request.
    public let metaData: MetaData?
    /// Custom text sequences that will cause the model to stop generating.
    public let stopSequences: [String]?
    /// Whether to incrementally stream the response using server-sent events.
    ///
    /// see [streaming](https://docs.anthropic.com/claude/reference/messages-streaming) for more detail.
    public let stream: Bool
    /// Amount of randomness injected into the response.
    ///
    /// Defaults to 1.0. Ranges from 0.0 to 1.0. Use temperature closer to 0.0 for analytical / multiple choice, and closer to 1.0 for creative and generative tasks.
    /// Note that even with temperature of 0.0, the results will not be fully deterministic.
    public let temperature: Double?
    /// Use nucleus sampling.
    ///
    /// In nucleus sampling, we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and cut it off once it reaches a particular probability specified by top_p. You should either alter temperature or top_p, but not both.
    /// Recommended for advanced use cases only. You usually only need to use temperature.
    public let topP: Double?
    /// Only sample from the top K options for each subsequent token.
    ///
    /// Used to remove "long tail" low probability responses.
    /// Recommended for advanced use cases only. You usually only need to use temperature.
    public let topK: Int?
    /// Definition of tools with names, descriptions, and input schemas in your API request.
    public let tools: [Tool]?
    /// Definition whether or not to force Claude to use the tool. ToolChoice should be set if tools are specified.
    public let toolChoice: ToolChoice?

    public init(
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
}

// TODO: remove this extension if it is not needed.
extension MessagesRequest {
    public func encode(with appendingObject: [String: Any], without removingObjectKeys: [String] = []) throws -> Data {
        let encoded = try anthropicJSONEncoder.encode(self)
        guard var dictionary = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any] else {
            return encoded
        }

        appendingObject.forEach { key, value in
            dictionary[key] = value
        }

        removingObjectKeys.forEach { key in
            dictionary.removeValue(forKey: key)
        }

        return try JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
}
