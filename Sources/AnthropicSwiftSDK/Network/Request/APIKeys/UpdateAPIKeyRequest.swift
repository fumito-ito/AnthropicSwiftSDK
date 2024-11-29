//
//  UpdateAPIKeyRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/11/29.
//

struct UpdateAPIKeyRequest: Request {
    typealias Body = APIKeyRequestBody
    let method: HttpMethod = .post
    var path: String {
        "\(RequestType.apiKey.basePath)/\(apiKeyId)"
    }
    let queries: [String : any CustomStringConvertible]? = nil

    let body: APIKeyRequestBody?
    let apiKeyId: String
}

struct APIKeyRequestBody: Encodable {
    let name: String
    let status: APIKeyStatus
}
