//
//  GetAPIKeyRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct GetAPIKeyRequest: Request {
    let method: HttpMethod = .get
    var path: String {
        "\(RequestType.apiKey.basePath)/\(apiKeyId)"
    }
    let queries: [String : any CustomStringConvertible]? = nil
    let body: Never? = nil

    let apiKeyId: String
}
