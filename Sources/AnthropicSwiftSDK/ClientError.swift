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
        }
    }
}
