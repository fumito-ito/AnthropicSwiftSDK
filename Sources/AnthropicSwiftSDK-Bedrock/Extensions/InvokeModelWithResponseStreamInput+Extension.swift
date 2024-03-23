//
//  InvokeModelWithResponseStreamInput+Extension.swift
//  
//
//  Created by 伊藤史 on 2024/03/23.
//

import Foundation
import AnthropicSwiftSDK
import AWSBedrockRuntime

extension InvokeModelWithResponseStreamInput {
    init(accept: String, request: MessagesRequest, contentType: String) throws {
        let data = try anthropicJSONEncoder.encode(request)

        self.init(
            accept: accept,
            body: data,
            contentType: contentType,
            modelId: request.model.bedrockModelName
        )
    }
}
