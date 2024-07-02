//
//  AnthropicBedrockClientError.swift
//
//
//  Created by 伊藤史 on 2024/03/25.
//

import Foundation
import AWSBedrockRuntime

public enum AnthropicBedrockClientError: Error {
    case cannotGetDataFromBedrockMessageResponse(InvokeModelOutput)
    case cannotGetDataFromBedrockStreamResponse(InvokeModelWithResponseStreamOutput)
    case bedrockRuntimeClientGetsUnknownPayload(BedrockRuntimeClientTypes.ResponseStream)
    case cannotGetDataFromBedrockClientPayload(BedrockRuntimeClientTypes.PayloadPart)
    case bedrockRuntimeClientGetsErrorInStream(String)
}
