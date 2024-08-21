//
//  MessagesSubject.swift
//  Example
//
//  Created by Fumito Ito on 2024/07/04.
//

import Foundation
import SwiftUI
import AnthropicSwiftSDK
import FunctionCalling

protocol MessagesSubject {
    var messages: [ChatMessage] { get }
    var errorMessage: String { get }
    var isShowingError: Bool { get set }
    var isLoading: Bool { get }
    var title: String { get }

    func cancel()
    func clear()
}

protocol SendMessagesSubject: MessagesSubject {
    init(messageHandler: MessageSendable, title: String, model: Model)

    func sendMessage(text: String) async throws
}

protocol StreamMessagesSubject: MessagesSubject {
    init(messageHandler: MessageStreamable, title: String, model: Model)

    func streamMessage(text: String) async throws
}

protocol MessageSendable {
    func createMessage(
        _ messages: [Message],
        model: Model,
        system: String?,
        maxTokens: Int,
        metaData: MetaData?,
        stopSequence: [String]?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        toolContainer: ToolContainer?,
        toolChoice: ToolChoice
    ) async throws -> MessagesResponse
}

protocol MessageStreamable {
    func streamMessage(
        _ messages: [Message],
        model: Model,
        system: String?,
        maxTokens: Int,
        metaData: MetaData?,
        stopSequence: [String]?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        toolContainer: ToolContainer?,
        toolChoice: ToolChoice
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error>
}
