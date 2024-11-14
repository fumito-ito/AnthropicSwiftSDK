//
//  SendBatchViewModel.swift
//  Example
//
//  Created by 伊藤史 on 2024/10/25.
//

import Foundation
import AnthropicSwiftSDK

@Observable class SendMessageBatchesViewModel: SendMessageBatchesSubject {
    
    private let messageHandler: MessageBatchSendable
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
    
    required init(
        messageHandler: any MessageBatchSendable,
        title: String,
        model: Model = .claude_3_5_Sonnet) {
            self.messageHandler = messageHandler
            self.title = title
            self.model = model

    }
    
    func sendMessageBatch(text: String) async throws {
        messages.append(.init(user: .user, text: text))
        
        let message = Message(role: .user, content: [.text(text)])
        let customId = UUID().uuidString
        let batch = MessageBatch(customId: customId, parameter: .init(messages: [message], maxTokens: 1024))

        task = Task {
            do {
                isLoading = true
                let result = try await messageHandler.createBatches(batches: [batch])
                let stream = try await messageHandler.results(streamOf: result.id)
                for try await chunk in stream {
                    guard case .text(let text, _) = chunk.result?.message?.content.first else {
                        return
                    }
                    messages.append(.init(user: .assistant, text: text))
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
