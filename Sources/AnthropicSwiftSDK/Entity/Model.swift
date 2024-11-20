//
//  Model.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// The model that will complete your prompt.
///
/// See [models](https://docs.anthropic.com/claude/docs/models-overview) for additional details and options.
public enum Model {
    /// Most powerful model for highly complex tasks
    // swiftlint:disable:next identifier_name
    case claude_3_Opus
    /// Ideal balance of intelligence and speed for enterprise workloads
    // swiftlint:disable:next identifier_name
    case claude_3_Sonnet
    /// Strong performance on highly complex tasks, such as math and coding.
    // swiftlint:disable:next identifier_name
    case claude_3_Haiku
    /// Most intelligent model, combining top-tier performance with improved speed.
    // swiftlint:disable:next identifier_name
    case claude_3_5_Sonnet
    /// Most intelligent model, combining top-tier performance with improved speed.
    // swiftlint:disable:next identifier_name
    case claude_3_5_Haiku
    /// Custom Model
    case custom(String)

    public init(modelName: String) {
        switch modelName {
        case Model.claude_3_Opus.stringfy:
            self = .claude_3_Opus
        case Model.claude_3_Sonnet.stringfy:
            self = .claude_3_Sonnet
        case Model.claude_3_Haiku.stringfy:
            self = .claude_3_Haiku
        case Model.claude_3_5_Sonnet.stringfy:
            self = .claude_3_5_Sonnet
        case Model.claude_3_5_Haiku.stringfy:
            self = .claude_3_5_Haiku
        default:
            self = .custom(modelName)
        }
    }
}

extension Model {
    /// Whether this model supports Message Batches API or not.
    ///
    /// `Claude 3.0 Sonnet` does not support it.
    var isSupportBatches: Bool {
        switch self {
        case
            .claude_3_Opus,
            .claude_3_Haiku,
            .claude_3_5_Sonnet,
            .claude_3_5_Haiku,
            .custom:
            return true
        case .claude_3_Sonnet:
            return false
        }
    }

    /// Whether this model supports Vision feature or not.
    ///
    /// `Claude 3.5 Haiku` does not support it.
    var isSupportVision: Bool {
        switch self {
        case
            .claude_3_Opus,
            .claude_3_Haiku,
            .claude_3_Sonnet,
            .claude_3_5_Sonnet,
            .custom:
            return true
        case .claude_3_5_Haiku:
            return false
        }
    }

    func isValid(for message: Message) -> Bool {
        if isSupportVision {
            return true
        }

        return message.content.allSatisfy { $0.contentType != .image }
    }
}

extension Model {
    var stringfy: String {
        switch self {
        case .claude_3_Opus:
            return "claude-3-opus-20240229"
        case .claude_3_Sonnet:
            return "claude-3-sonnet-20240229"
        case .claude_3_Haiku:
            return "claude-3-haiku-20240307"
        case .claude_3_5_Sonnet:
            return "claude-3-5-sonnet-20241022"
        case .claude_3_5_Haiku:
            return "claude-3-5-haiku-20241029"
        case let .custom(modelName):
            return modelName
        }
    }
}

extension Model: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.stringfy)
    }
}

extension Model: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let modelName = try container.decode(String.self)
        self = .init(modelName: modelName)
    }
}
