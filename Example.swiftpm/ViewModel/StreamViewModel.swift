//
//  StreamViewModel.swift
//
//
//  Created by Fumito Ito on 2024/07/05.
//

import Foundation
import AnthropicSwiftSDK

@Observable class StreamViewModel: StreamMessagesSubject {
    private let messageHandler: MessageStreamable
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

    required init(messageHandler: any MessageStreamable, title: String, model: Model = .claude_3_5_Sonnet) {
        self.messageHandler = messageHandler
        self.title = title
        self.model = model
    }
    
    func streamMessage(text: String) async throws {
        messages.append(.init(user: .user, text: text))

        let message = Message(role: .user, content: [.text(text)])
        task = Task {
            do {
                isLoading = true
                let stream = try await self.messageHandler.streamMessage(
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
                for try await chunk in stream {
                    switch chunk.type {
                    case .contentBlockDelta:
                        if let response = chunk as? StreamingContentBlockDeltaResponse {
                            messages.append(.init(user: .assistant, text: response.delta.text ?? ""))
                        }
                    default:
                        break
                    }
                }
                isLoading = false
            } catch {
                self.errorMessage = "\(error)"
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
