//
//  Batches.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

import Foundation
import FunctionCalling
import SwiftyJSONLines

/// A class responsible for managing message batches in the Anthropic API.
public struct MessageBatches {
    /// The API key used for authentication with the Anthropic API.
    private let apiKey: String
    /// The URL session used for network requests.
    private let session: URLSession

    /// Initializes a new instance of `MessageBatches`.
    ///
    /// - Parameters:
    ///   - apiKey: The API key for authentication.
    ///   - session: The URL session for network requests.
    init(apiKey: String, session: URLSession) {
        self.apiKey = apiKey
        self.session = session
    }

    /// Creates new message batches.
    ///
    /// - Parameter batches: An array of `MessageBatch` to be created.
    /// - Returns: A `BatchResponse` containing the details of the created batches.
    /// - Throws: An error if the request fails.
    public func createBatches(batches: [MessageBatch]) async throws -> BatchResponse {
        try await createBatches(
            batches: batches,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    /// Creates new message batches with custom header providers.
    ///
    /// - Parameters:
    ///   - batches: An array of `MessageBatch` to be created.
    ///   - anthropicHeaderProvider: The provider for Anthropic-specific headers.
    ///   - authenticationHeaderProvider: The provider for authentication headers.
    /// - Returns: A `BatchResponse` containing the details of the created batches.
    /// - Throws: An error if the request fails.
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

    /// Retrieves a specific message batch by its ID.
    ///
    /// - Parameter batchId: The ID of the batch to retrieve.
    /// - Returns: A `BatchResponse` containing the details of the retrieved batch.
    /// - Throws: An error if the request fails.
    public func retrieve(batchId: String) async throws -> BatchResponse {
        try await retrieve(
            batchId: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    /// Retrieves a specific message batch by its ID with custom header providers.
    ///
    /// - Parameters:
    ///   - batchId: The ID of the batch to retrieve.
    ///   - anthropicHeaderProvider: The provider for Anthropic-specific headers.
    ///   - authenticationHeaderProvider: The provider for authentication headers.
    /// - Returns: A `BatchResponse` containing the details of the retrieved batch.
    /// - Throws: An error if the request fails.
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

    /// Retrieves the results of a specific message batch by its ID.
    ///
    /// - Parameter batchId: The ID of the batch to retrieve results for.
    /// - Returns: An array of `BatchResultResponse` containing the results of the batch.
    /// - Throws: An error if the request fails.
    public func results(of batchId: String) async throws -> [BatchResultResponse] {
        try await results(
            of: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    /// Retrieves the results of a specific message batch by its ID with custom header providers.
    ///
    /// - Parameters:
    ///   - batchId: The ID of the batch to retrieve results for.
    ///   - anthropicHeaderProvider: The provider for Anthropic-specific headers.
    ///   - authenticationHeaderProvider: The provider for authentication headers.
    /// - Returns: An array of `BatchResultResponse` containing the results of the batch.
    /// - Throws: An error if the request fails.
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

        return try JSONLines(data: data).toObjects(with: anthropicJSONDecoder)
    }

    /// Streams the results of a specific message batch by its ID.
    ///
    /// - Parameter batchId: The ID of the batch to stream results for.
    /// - Returns: An `AsyncThrowingStream` of `BatchResultResponse` containing the streamed results of the batch.
    /// - Throws: An error if the request fails.
    public func results(streamOf batchId: String) async throws -> AsyncThrowingStream<BatchResultResponse, Error> {
        try await results(
            streamOf: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    /// Streams the results of a specific message batch by its ID with custom header providers.
    ///
    /// - Parameters:
    ///   - batchId: The ID of the batch to stream results for.
    ///   - anthropicHeaderProvider: The provider for Anthropic-specific headers.
    ///   - authenticationHeaderProvider: The provider for authentication headers.
    /// - Returns: An `AsyncThrowingStream` of `BatchResultResponse` containing the streamed results of the batch.
    /// - Throws: An error if the request fails.
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

    /// Lists message batches with optional pagination.
    ///
    /// - Parameters:
    ///   - beforeId: The ID to list batches before.
    ///   - afterId: The ID to list batches after.
    ///   - limit: The maximum number of batches to list.
    /// - Returns: A `BatchListResponse` containing the list of batches.
    /// - Throws: An error if the request fails.
    public func list(beforeId: String? = nil, afterId: String? = nil, limit: Int = 20) async throws -> BatchListResponse {
        try await list(
            beforeId: beforeId,
            afterId: afterId,
            limit: limit,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    /// Lists message batches with optional pagination and custom header providers.
    ///
    /// - Parameters:
    ///   - beforeId: The ID to list batches before.
    ///   - afterId: The ID to list batches after.
    ///   - limit: The maximum number of batches to list.
    ///   - anthropicHeaderProvider: The provider for Anthropic-specific headers.
    ///   - authenticationHeaderProvider: The provider for authentication headers.
    /// - Returns: A `BatchListResponse` containing the list of batches.
    /// - Throws: An error if the request fails.
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

    /// Cancels a specific message batch by its ID.
    ///
    /// - Parameter batchId: The ID of the batch to cancel.
    /// - Returns: A `BatchResponse` containing the details of the canceled batch.
    /// - Throws: An error if the request fails.
    public func cancel(batchId: String) async throws -> BatchResponse {
        try await cancel(
            batchId: batchId,
            anthropicHeaderProvider: DefaultAnthropicHeaderProvider(),
            authenticationHeaderProvider: APIKeyAuthenticationHeaderProvider(apiKey: apiKey)
        )
    }

    /// Cancels a specific message batch by its ID with custom header providers.
    ///
    /// - Parameters:
    ///   - batchId: The ID of the batch to cancel.
    ///   - anthropicHeaderProvider: The provider for Anthropic-specific headers.
    ///   - authenticationHeaderProvider: The provider for authentication headers.
    /// - Returns: A `BatchResponse` containing the details of the canceled batch.
    /// - Throws: An error if the request fails.
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
