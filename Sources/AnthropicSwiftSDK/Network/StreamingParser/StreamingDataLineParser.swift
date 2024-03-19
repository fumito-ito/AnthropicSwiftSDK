//
//  StreamingDataLineParser.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

enum StreamingDataLineParser {
    static func parse<T>(dataLine line: String) throws -> T where T: StreamingResponse {
        // data line has `data: json` structure and json value might have `data: ` string
        let jsonString = String(line.dropFirst(6))
        guard let data = jsonString.data(using: .utf8) else {
            throw ClientError.cannotHandleDataOfDataLine(jsonString)
        }

        return try anthropicJSONDecoder.decode(T.self, from: data)
    }
}
