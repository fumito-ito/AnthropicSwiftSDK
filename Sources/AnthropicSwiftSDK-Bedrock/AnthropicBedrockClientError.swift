//
//  AnthropicBedrockClientError.swift
//
//
//  Created by 伊藤史 on 2024/03/25.
//

import Foundation
import AWSBedrockRuntime

public enum AnthropicBedrockClientError: Error {
    case cannotGetAnyDataFromBedrockMessageResponse(InvokeModelOutput)
    case cannotGetAnyDataFromBedrockStreamResponse(InvokeModelWithResponseStreamOutput)
    case bedrockRuntimeClientGetsUnknownPayload(BedrockRuntimeClientTypes.ResponseStream)
    case cannotGetAnyDataFromBedrockRuntimeClientPayload(BedrockRuntimeClientTypes.PayloadPart)
}
