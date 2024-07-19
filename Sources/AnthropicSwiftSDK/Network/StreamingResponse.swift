//
//  StreamingResponse.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public protocol StreamingResponse: Decodable {
    var type: StreamingEvent { get }
}

public struct StreamingPingResponse: StreamingResponse {
    public let type: StreamingEvent
}

public struct StreamingMessageStartResponse: StreamingResponse {
    public let type: StreamingEvent
    public let message: MessagesResponse
}

public struct StreamingMessageDeltaResponse: StreamingResponse {
    public let type: StreamingEvent
    public let delta: MessageDelta
    public let usage: TokenUsage
}

public struct StreamingMessageStopResponse: StreamingResponse {
    public let type: StreamingEvent
}

public struct StreamingContentBlockStartResponse: StreamingResponse {
    public let type: StreamingEvent
    public let index: Int
    public let contentBlock: Content
}

public struct StreamingContentBlockDeltaResponse: StreamingResponse {
    public let type: StreamingEvent
    public let index: Int
    public let delta: ContentBlockDelta
}

public struct StreamingContentBlockStopResponse: StreamingResponse {
    public let type: StreamingEvent
    public let index: Int
}

public struct StreamingErrorResponse: StreamingResponse {
    public let type: StreamingEvent
    public let error: StreamingError
}
