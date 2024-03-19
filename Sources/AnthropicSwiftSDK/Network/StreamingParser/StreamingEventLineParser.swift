//
//  StreamingEventLineParser.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

enum StreamingEventLineParser {
    static func parse(eventLine line: String) throws -> StreamingEvent {
        // event line has `event: event_name` structure
        let eventName = line.replacingOccurrences(of: "event: ", with: "")

        guard let event = StreamingEvent(rawValue: eventName) else {
            throw ClientError.unknownStreamingEvent(eventName)
        }

        return event
    }
}
