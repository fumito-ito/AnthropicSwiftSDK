//
//  ListObjectRequest.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/16.
//

struct ListObjectRequest: Request {
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

    /// HTTP method of request. It's always `GET`
    let method: HttpMethod = .get
    /// HTTP request path. It's always base path of `type`.
    var path: String {
        type.basePath
    }
    /// HTTP request body. It's always empty
    let body: Never? = nil

    let queries: [String: CustomStringConvertible]?
    /// type of objects
    let type: RequestType
}
