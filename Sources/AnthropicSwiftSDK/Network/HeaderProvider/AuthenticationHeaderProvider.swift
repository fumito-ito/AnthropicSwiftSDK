//
//  AuthenticationHeaderProvider.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// Authentication information provider for Anthropic API
///
/// for other header informations, use `AnthropicHeaderProvider`.
public protocol AuthenticationHeaderProvider {
    func getAuthenticationHeaders() -> [String: String]
}

struct APIKeyAuthenticationHeaderProvider: AuthenticationHeaderProvider {
    func getAuthenticationHeaders() -> [String : String] {
        ["x-api-key": apiKey]
    }
    
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
