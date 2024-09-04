//
//  ClientError.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Errors in swift SDK
public enum ClientError: Error {
    /// Received unknown event in Stream.
    case unknownStreamingEvent(String)
    /// Received in Stream with unknown line type.
    case unknownStreamingResponseLine(String)
    /// URLRequest could not be cast to HTTPURLRequest
    case cannotHandleURLResponse(URLResponse)
    /// The DataLine string returned from Stream could not be cast to the Data attribute.
    case cannotHandleDataOfDataLine(String)
    /// Failed to decode response as `ContentType`
    case failedToParseContentType(String)
    /// Claude API returns `tool_use` response but any tools are not defined in SDK
    case anyToolsAreDefined
    /// Claude API returns `tool_use` response but any tool_use contents are not defined in response
    case cannotFindToolUseContentFromResponse(MessagesResponse)
    /// Claude API returns `tool_use` response but any tool_use contents are not defined in content_block_start chunk
    case cannotFindToolUseContentFromContentBlockStart(Content?)
    /// SDK tries to aggregate partial json string into JSON object but failed
    case failedToAggregatePartialJSONStringIntoJSONObject(String)
    /// SDK failed to decode tool_use content
    case failedToDecodeToolUseContent
    /// SDK failed to make `ToolUse.input` encodable
    case failedToMakeEncodableToolUseInput([String: Any])

    /// Description of sdk internal errors.
    public var localizedDescription: String {
        switch self {
        case let .unknownStreamingEvent(eventName):
            return "There is unknow streaming event named `\(eventName)`"
        case let .unknownStreamingResponseLine(line):
            return "There is unkonw streaming line type. This library only supports `empty`, `data: ` and `event: ` but receive \(line)."
        case let .cannotHandleURLResponse(response):
            return "Cannot cast \(response) to HTTPURLResponse."
        case let .cannotHandleDataOfDataLine(line):
            return "Cannot get Data object using `data(using: .utf8)` from \(line)"
        case let .failedToParseContentType(contentTypeString):
            return "Failed to parse content type from \(contentTypeString)"
        case .anyToolsAreDefined:
            return "Claude returns tool_use but any tools are defined"
        case let .cannotFindToolUseContentFromResponse(messagesResponse):
            return "Cannot find any tool_use content from \(messagesResponse.content)"
        case let .cannotFindToolUseContentFromContentBlockStart(content):
            return "Cannot find any tool_use content from \(String(describing: content))"
        case let .failedToAggregatePartialJSONStringIntoJSONObject(comparedString):
            return "Failed to aggregate partial json string into json objecct: \(comparedString)"
        case .failedToDecodeToolUseContent:
            return "Failed to decode into tool use content"
        case .failedToMakeEncodableToolUseInput:
            return "Failed to make ToolUse.input object Encodable"
        }
    }
}
