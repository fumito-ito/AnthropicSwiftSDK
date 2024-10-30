//
//  SendViewModel.swift
//
//
//  Created by Fumito Ito on 2024/07/05.
//

import Foundation
import AnthropicSwiftSDK

@Observable class SendViewModel: SendMessagesSubject {
    private let messageHandler: MessageSendable
    let title: String
    let model: Model

    var messages: [ChatMessage] = []

    var errorMessage: String = "" {
        didSet {
            isShowingError = errorMessage.isEmpty == false
        }
    }

    var isShowingError: Bool = false

    var isLoading: Bool = false

    private var task: Task<Void, Never>? = nil

    required init(messageHandler: any MessageSendable, title: String, model: Model = .claude_3_5_Sonnet) {
        self.messageHandler = messageHandler
        self.title = title
        self.model = model
    }
    
    func sendMessage(text: String) async throws {
        messages.append(.init(user: .user, text: text))

        let message = Message(role: .user, content: [.text(text)])
        task = Task {
            do {
                isLoading = true
                let result = try await messageHandler.createMessage(
                    [message],
                    model: model,
                    system: [],
                    maxTokens: 1024,
                    metaData: nil,
                    stopSequence: nil,
                    temperature: nil,
                    topP: nil,
                    topK: nil,
                    tools: nil,
                    toolChoice: .auto
                )

                if case let .text(reply) = result.content.first {
                    messages.append(.init(user: .assistant, text: reply))
                }
                isLoading = false
            } catch {
                errorMessage = "\(error)"
                isLoading = false
            }
        }
    }
    
    func cancel() {
        task?.cancel()
    }
    
    func clear() {
        messages = []
    }
}
