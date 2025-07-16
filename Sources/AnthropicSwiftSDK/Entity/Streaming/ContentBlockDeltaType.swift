//
//  ContentBlockDeltaType.swift
//  
//
//  Created by 伊藤史 on 2024/07/19.
//

import Foundation

public enum ContentBlockDeltaType: String, Decodable, Sendable {
    case text = "text_delta"
    case inputJSON = "input_json_delta"
}
