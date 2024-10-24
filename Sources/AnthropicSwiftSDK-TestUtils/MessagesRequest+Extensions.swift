//
//  MessagesRequest+Extensions.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation
import AnthropicSwiftSDK

public struct NopRequest: Request {
    public let method: HttpMethod
    public let path: String
    public let queries: [String : any CustomStringConvertible]? = nil
    public let body: Never? = nil

    public init(
        method: HttpMethod = .post,
        path: String = "/v1/messages"
    ) {
        self.method = method
        self.path = path
    }
}
