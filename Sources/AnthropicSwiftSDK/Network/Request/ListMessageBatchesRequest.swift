//
//  ListMessageBatchesRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

/// List all Message Batches within a Workspace. Most recently created batches are returned first.
struct ListMessageBatchesRequest: Request {
    let method: HttpMethod = .get
    let path: String = RequestType.batches.basePath
    let queries: [String: CustomStringConvertible]?
    let body: Never? = nil

    enum Parameter: String {
        /// ID of the object to use as a cursor for pagination. When provided, returns the page of results immediately before this object.
        case beforeId = "before_id"
        /// ID of the object to use as a cursor for pagination. When provided, returns the page of results immediately after this object.
        case afterId = "after_id"
        /// Number of items to return per page.
        ///
        /// Defaults to 20. Ranges from 1 to 100.
        case limit
    }
}
