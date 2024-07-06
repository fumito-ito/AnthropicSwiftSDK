//
//  MockViewModel.swift
//
//
//  Created by Fumito Ito on 2024/07/05.
//

import Foundation
import AnthropicSwiftSDK

@Observable class MockViewModel: StreamMessagesSubject, SendMessagesSubject {
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
    func streamMessage(_ messages: [AnthropicSwiftSDK.Message], model: AnthropicSwiftSDK.Model, system: String?, maxTokens: Int, metaData: AnthropicSwiftSDK.MetaData?, stopSequence: [String]?, temperature: Double?, topP: Double?, topK: Int?) async throws -> AsyncThrowingStream<any AnthropicSwiftSDK.StreamingResponse, any Error> {
        fatalError()
    }
}

struct MockMessagesSendable: MessageSendable {
    func createMessage(_ messages: [AnthropicSwiftSDK.Message], model: AnthropicSwiftSDK.Model, system: String?, maxTokens: Int, metaData: AnthropicSwiftSDK.MetaData?, stopSequence: [String]?, temperature: Double?, topP: Double?, topK: Int?) async throws -> AnthropicSwiftSDK.MessagesResponse {
        fatalError()
    }
}
