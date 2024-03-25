//
//  MessagesResponse+Extension.swift
//
//
//  Created by 伊藤史 on 2024/03/23.
//

import Foundation
import AnthropicSwiftSDK
import AWSBedrockRuntime

extension MessagesResponse {
    init (from invokeModelOutput: InvokeModelOutput) throws {
        guard let data = invokeModelOutput.body else {
            throw AnthropicBedrockClientError.cannotGetAnyDataFromBedrockMessageResponse(invokeModelOutput)
        }

        self = try anthropicJSONDecoder.decode(MessagesResponse.self, from: data)
    }
}
