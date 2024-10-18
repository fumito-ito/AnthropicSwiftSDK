//
//  Batches.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

import Foundation
import FunctionCalling

public struct MessageBatches {
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }

    public func createBatches(batches: [MessageBatch]) async throws -> BatchResponse {
        try await createBatches(
            batches: batches,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }
    
    public func createBatches(
        batches: [MessageBatch],
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> BatchResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = MessageBatchesRequest(body: .init(from: batches))
        let (data, response) = try await client.send(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try anthropicJSONDecoder.decode(BatchResponse.self, from: data)
    }

    public func retrieve(batchId: String) async throws -> BatchResponse {
        try await retrieve(
            batchId: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }
    
    public func retrieve(
        batchId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> BatchResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = RetrieveMessageBatchesRequest(batchId: batchId)
        let (data, response) = try await client.send(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try anthropicJSONDecoder.decode(BatchResponse.self, from: data)
    }

    public func results(of batchId: String) async throws -> [BatchResultResponse] {
        try await results(
            of: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }
    
    public func results(
        of batchId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> [BatchResultResponse] {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = RetrieveMessageBatchResultsRequest(batchId: batchId)
        let (data, response) = try await client.send(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try anthropicJSONDecoder.decode([BatchResultResponse].self, from: data)
    }
    
    public func results(streamOf batchId: String) async throws -> AsyncThrowingStream<BatchResultResponse, Error> {
        try await results(
            streamOf: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }
    
    public func results(
        streamOf batchId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> AsyncThrowingStream<BatchResultResponse, Error> {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = RetrieveMessageBatchResultsRequest(batchId: batchId)
        let (data, response) = try await client.stream(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }
        
        return AsyncThrowingStream.init { continuation in
            let task = Task {
                for try await line in data.lines {
                    guard let data = line.data(using: .utf8) else {
                        return
                    }
                    
                    continuation.yield(try anthropicJSONDecoder.decode(BatchResultResponse.self, from: data))
                }
                continuation.finish()
            }
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }

    public func list(beforeId: String? = nil, afterId: String? = nil, limit: Int = 20) async throws -> BatchListResponse {
        try await list(
            beforeId: beforeId,
            afterId: afterId,
            limit: limit,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }
    
    public func list(
        beforeId: String?,
        afterId: String?,
        limit: Int,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> BatchListResponse  {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let queries: [String: CustomStringConvertible] = {
            var queries: [String: CustomStringConvertible] = [ListMessageBatchesRequest.Parameter.limit.rawValue: limit]
            if let beforeId {
                queries[ListMessageBatchesRequest.Parameter.beforeId.rawValue] = beforeId
            }
            if let afterId {
                queries[ListMessageBatchesRequest.Parameter.afterId.rawValue] = afterId
            }
            
            return queries
        }()

        let request = ListMessageBatchesRequest(queries: queries)
        let (data, response) = try await client.send(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try anthropicJSONDecoder.decode(BatchListResponse.self, from: data)
    }

    public func cancel(batchId: String) async throws -> BatchResponse {
        try await cancel(
            batchId: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }
    
    public func cancel(
        batchId: String,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> BatchResponse {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let request = CancelMessageBatchRequest(batchId: batchId)
        let (data, response) = try await client.send(request: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClientError.cannotHandleURLResponse(response)
        }

        guard httpResponse.statusCode == 200 else {
            throw AnthropicAPIError(fromHttpStatusCode: httpResponse.statusCode)
        }

        return try anthropicJSONDecoder.decode(BatchResponse.self, from: data)

    }
}
