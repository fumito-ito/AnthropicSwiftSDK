//
//  BatchResultType.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/09.
//

/// Once batch processing has ended, each Messages request in the batch will have a result.
public enum BatchResultType: String, Decodable {
    /// Request was successful. Includes the message result.
    case succeeded
    /// Request encountered an error and a message was not created.
    ///
    /// Possible errors include invalid requests and internal server errors. You will not be billed for these requests.
    case errored
    /// User canceled the batch before this request could be sent to the model. You will not be billed for these requests.
    case cancelled
    /// Batch reached its 24 hour expiration before this request could be sent to the model. You will not be billed for these requests.
    case expired
}
