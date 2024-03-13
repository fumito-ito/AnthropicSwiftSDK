//
//  AnthropicHeaderProvider.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Header provider for Anthropic API
///
/// For authentication headers, use `AuthenticationHeaderProvider`.
public protocol AnthropicHeaderProvider {
    func getAnthropicAPIHeaders() -> [String: String]
}

struct DefaultAnthropicHeaderProvider: AnthropicHeaderProvider {
    let version: AnthropicVersion
    let useBeta: Bool
    /// content type of response, now only support JSON
    let contentType = "application/json"

    private let betaDescription = "messages-2023-12-15"

    func getAnthropicAPIHeaders() -> [String : String] {
        var headers: [String: String] = [
            "anthropic-version": version.stringfy,
            "content-type": contentType
        ]

        if useBeta {
            headers.updateValue(betaDescription, forKey: "anthropic-beta")
            return headers
        } else {
            return headers
        }
    }

    init(version: AnthropicVersion = .v2023_06_01, useBeta: Bool = true) {
        self.version = version
        self.useBeta = useBeta
    }
}
