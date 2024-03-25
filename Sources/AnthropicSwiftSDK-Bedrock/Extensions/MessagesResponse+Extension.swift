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
    /// Create `MessagesResponse` object from InvokeModelOutput.
    ///
    /// This constructor converts `InvokeModelOutput.body` into `MessageResponse`
    /// - Parameter invokeModelOutput: model output to convert `MessageResponse`
    init (from invokeModelOutput: InvokeModelOutput) throws {
        guard let data = invokeModelOutput.body else {
            throw AnthropicBedrockClientError.cannotGetAnyDataFromBedrockMessageResponse(invokeModelOutput)
        }

        self = try anthropicJSONDecoder.decode(MessagesResponse.self, from: data)
    }
}
