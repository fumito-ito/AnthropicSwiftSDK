//
//  VertexAIClientError.swift
//
//
//  Created by 伊藤史 on 2024/04/04.
//

import Foundation
import AnthropicSwiftSDK

enum VertexAIClientError: Error {
    case notSupportedModel(Model)

    var localizedDescription: String {
        switch self {
        case let .notSupportedModel(modelName):
            return "\(modelName) is not supported model."
        }
    }
}
