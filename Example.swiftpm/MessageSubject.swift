//
//  MessageSubject.swift
//  Example
//
//  Created by 伊藤史 on 2024/03/18.
//

import Foundation
import SwiftUI
import AnthropicSwiftSDK

@Observable class MessageSubject {

    var message: String = ""
    var errorMessage: String = ""
    var isLoading = false
    private let anthropic: Anthropic

    init(apiKey: String) {
        self.anthropic = Anthropic(apiKey: apiKey)
    }

    func streamMessage(text: String) async throws {
        let message = Message(role: .user, content: [.text(text)])
        task = Task {
            do {
                isLoading = true
                let stream = try await anthropic.messages.streamMessage(message, maxTokens: 1024)
                for try await chunk in stream {
                    switch chunk.type {
                    case .contentBlockDelta:
                        if let response = chunk as? StreamingContentBlockDeltaResponse {
                            self.message += response.delta.text
                        }
                    default:
                        break
                    }
                }
                isLoading = false
            } catch {
                self.errorMessage = "\(error)"
            }
        }
    }

    func cancelStream() {
        task?.cancel()
    }

    func clearMessage() {
        message = ""
    }

    // MARK: Private

    private var task: Task<Void, Never>? = nil

}
