//
//  BatchRequestCounts.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

public struct BatchRequestCounts: Decodable {
    let processing: Int
    let succeeeded: Int
    let errored: Int
    let canceled: Int
    let expired: Int
}
