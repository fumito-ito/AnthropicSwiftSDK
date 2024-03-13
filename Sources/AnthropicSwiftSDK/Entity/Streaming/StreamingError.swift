//
//  StreamingError.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public struct StreamingError: Decodable {
    public let type: AnthropicAPIError
    public let message: String
}
