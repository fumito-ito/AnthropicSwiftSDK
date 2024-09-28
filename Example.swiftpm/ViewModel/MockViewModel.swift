//
//  MockViewModel.swift
//
//
//  Created by Fumito Ito on 2024/07/05.
//

import Foundation
import AnthropicSwiftSDK
import FunctionCalling

@Observable class MockViewModel: StreamMessagesSubject, SendMessagesSubject {
    required init(messageHandler: any MessageStreamable, title: String, model: AnthropicSwiftSDK.Model) {
    }
    
    required init(messageHandler: any MessageSendable, title: String, model: AnthropicSwiftSDK.Model) {
    }
    
    required init(messageHandler: any MessageStreamable, title: String) {
    }
    
    required init(messageHandler: any MessageSendable, title: String) {
    }

    func sendMessage(text: String) async throws {
    }
    
    func streamMessage(text: String) async throws {
    }
    
    var messages: [ChatMessage] = [
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text"),
        .init(user: .user, text: "This is user text"),
        .init(user: .assistant, text: "This is assistant text")
    ]

    var errorMessage: String = ""

    var isShowingError: Bool = false

    var isLoading: Bool = false

    var title: String = ""

    func cancel() {
    }
    
    func clear() {
    }
}

struct MockMessageStreamable: MessageStreamable {
    func streamMessage(_ messages: [AnthropicSwiftSDK.Message], model: AnthropicSwiftSDK.Model, system: [AnthropicSwiftSDK.SystemPrompt], maxTokens: Int, metaData: AnthropicSwiftSDK.MetaData?, stopSequence: [String]?, temperature: Double?, topP: Double?, topK: Int?, toolContainer: (any FunctionCalling.ToolContainer)?, toolChoice: AnthropicSwiftSDK.ToolChoice) async throws -> AsyncThrowingStream<any AnthropicSwiftSDK.StreamingResponse, any Error> {
        fatalError()
    }
}

struct MockMessagesSendable: MessageSendable {
    func createMessage(_ messages: [Message], model: Model, system: [SystemPrompt], maxTokens: Int, metaData: MetaData?, stopSequence: [String]?, temperature: Double?, topP: Double?, topK: Int?, toolContainer: (any ToolContainer)?, toolChoice: ToolChoice) async throws -> MessagesResponse {
        fatalError()
    }
}
