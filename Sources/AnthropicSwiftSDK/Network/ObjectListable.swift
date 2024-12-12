//
//  ObjectListable.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/12/03.
//
import Foundation

protocol ObjectListable<Object> {
    associatedtype Object: Decodable
}

extension ObjectListable {
    // swiftlint:disable:next function_parameter_count
    func list(
        session: URLSession,
        type: RequestType,
        limit: Int,
        beforeId: String?,
        afterId: String?,
        anthropicHeaderProvider: AnthropicHeaderProvider,
        authenticationHeaderProvider: AuthenticationHeaderProvider
    ) async throws -> ObjectListResponse<Object> {
        let client = APIClient(
            session: session,
            anthropicHeaderProvider: anthropicHeaderProvider,
            authenticationHeaderProvider: authenticationHeaderProvider
        )

        let queries: [String: CustomStringConvertible] = {
            var queries: [String: CustomStringConvertible] = [ListObjectRequest.Parameter.limit.rawValue: limit]
            if let beforeId {
                queries[ListObjectRequest.Parameter.beforeId.rawValue] = beforeId
            }
            if let afterId {
                queries[ListObjectRequest.Parameter.afterId.rawValue] = afterId
            }

            return queries
        }()

        return try await client.send(request: ListObjectRequest(queries: queries, type: type))
    }
}
