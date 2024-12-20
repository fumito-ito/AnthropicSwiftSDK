//
//  MessagesSubject.swift
//  Example
//
//  Created by Fumito Ito on 2024/07/04.
//

import Foundation
import SwiftUI
import AnthropicSwiftSDK

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

protocol SendMessageBatchesSubject: MessagesSubject {
    init(messageHandler: MessageBatchSendable, title: String, model: Model)
    
    func sendMessageBatch(text: String) async throws
}

protocol MessageSendable {
    func createMessage(
        _ messages: [Message],
        model: Model,
        system: [SystemPrompt],
        maxTokens: Int,
        metaData: MetaData?,
        stopSequence: [String]?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        tools: [Tool]?,
        toolChoice: ToolChoice
    ) async throws -> MessagesResponse
}

protocol MessageBatchSendable {
    func createBatches(batches: [MessageBatch]) async throws -> BatchResponse
    
    func results(streamOf batchId: String) async throws -> AsyncThrowingStream<BatchResultResponse, Error>
}

protocol MessageStreamable {
    func streamMessage(
        _ messages: [Message],
        model: Model,
        system: [SystemPrompt],
        maxTokens: Int,
        metaData: MetaData?,
        stopSequence: [String]?,
        temperature: Double?,
        topP: Double?,
        topK: Int?,
        tools: [Tool]?,
        toolChoice: ToolChoice
    ) async throws -> AsyncThrowingStream<StreamingResponse, Error>
}
