//
//  Batches.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

public struct MessageBatches {
    public func createBatches() {}

    public func retrieve(batchId: String) {}

    public func results(of batchId: String) {}

    public func list(beforeId: String? = nil, afterId: String? = nil, limit: Int = 20) {}

    public func cancel(batchId: String) {}
}
