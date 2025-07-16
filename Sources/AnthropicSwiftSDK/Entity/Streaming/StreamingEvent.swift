//
//  StreamingEvent.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public enum StreamingEvent: String, Decodable, Sendable {
    /// contains a `Message` object with empty content
    case messageStart = "message_start"
    /// A series of content blocks, each of which have a `content_block_start`, one or more `content_block_delta` events, and a `content_block_stop` event. Each content block will have an `index` that corresponds to its index in the final `Message` content array.
    case contentBlockStart = "content_block_start"
    /// A series of content blocks, each of which have a `content_block_start`, one or more `content_block_delta` events, and a `content_block_stop` event. Each content block will have an `index` that corresponds to its index in the final `Message` content array.
    case contentBlockDelta = "content_block_delta"
    /// A series of content blocks, each of which have a `content_block_start`, one or more `content_block_delta` events, and a `content_block_stop` event. Each content block will have an `index` that corresponds to its index in the final `Message` content array.
    case contentBlockStop = "content_block_stop"
    /// One or more `message_delta` events, indicating top-level changes to the final Message object.
    case messageDelta = "message_delta"
    /// A final `message_stop` event.
    case messageStop = "message_stop"
    /// Event streams may also include any number of `ping` events.
    case ping
    /// We may occasionally send errors in the event stream. For example, during periods of high usage, you may receive an `overloaded_error`, which would normally correspond to an HTTP 529 in a non-streaming context:
    case error
}
