//
//  AnthropicVertex.swift
//  
//
//  Created by 伊藤史 on 2024/03/26.
//

import Foundation
import AnthropicSwiftSDK

public final class AnthropicVertex {
    let messages: Messages

    public init(projectId: String, accessToken: String, region: SupportedRegion = .usCentral1) {
        self.messages = Messages(projectId: projectId, accessToken: accessToken, region: region)
    }
}
