//
//  StreamingResponseParser.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

enum StreamingResponseLineType {
    case empty
    case event
    case data
}

enum StreamingResponseParser {
    /// line is these kinds
    /// - `event: event_name`
    /// - `data: json`
    /// - `(empty line)`
    static func parse(line: String) throws -> StreamingResponseLineType {
        guard let firstCharacter = line.first else {
            return .empty
        }

        switch firstCharacter {
        case "e":
            return .event
        case "d":
            return .data
        default:
            throw ClientError.unknownStreamingResponseLine(line)
        }
    }
}
