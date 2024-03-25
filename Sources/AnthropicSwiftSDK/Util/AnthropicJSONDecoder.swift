//
//  anthropicJSONDecoder.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public let anthropicJSONDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return decoder
}()
