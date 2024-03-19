//
//  anthropicJSONDecoder.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

let anthropicJSONDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return decoder
}()
