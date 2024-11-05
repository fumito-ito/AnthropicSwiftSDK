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

    private var betaDescription: String {
        BetaFeatures.allCases.map { $0.rawValue }.joined(separator: ",")
    }

    func getAnthropicAPIHeaders() -> [String: String] {
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

/// Anthropic API beta features supported by this library
public enum BetaFeatures: String, CaseIterable {
    /// Message Batches (beta)
    ///
    /// https://docs.anthropic.com/en/docs/build-with-claude/message-batches
    case messageBatches = "message-batches-2024-09-24"
    /// Computer use (beta)
    ///
    /// https://docs.anthropic.com/en/docs/build-with-claude/computer-use
    case computerUse = "computer-use-2024-10-22"
    /// Prompt caching (beta)
    ///
    /// https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching
    case promptCaching = "prompt-caching-2024-07-31"
    /// PDF Support (beta)
    ///
    /// https://docs.anthropic.com/en/docs/build-with-claude/pdf-support
    case pdfSupport = "pdfs-2024-09-25"
}
