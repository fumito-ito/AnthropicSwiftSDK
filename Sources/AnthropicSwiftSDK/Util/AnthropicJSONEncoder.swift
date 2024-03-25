//
//  AnthropicJSONEncoder.swift
//
//
//  Created by 伊藤史 on 2024/03/23.
//

import Foundation

public let anthropicJSONEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase

    return encoder
}()
