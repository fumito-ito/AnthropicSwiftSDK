//
//  AnthropicError.swift
//
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

/// https://docs.anthropic.com/claude/reference/errors
public enum AnthropicAPIError: String, Decodable, Error {
    case invalidRequestError = "invalid_request_error"
    case authenticationError = "authentication_error"
    case permissionError = "permission_error"
    case notFoundError = "not_found_error"
    case rateLimitError = "rate_limit_error"
    case apiError = "api_error"
    case overloadedError = "overloaded_error"
    case unknown

    /// Description of Anthropic API errors.
    ///
    /// for more detail, see https://docs.anthropic.com/claude/reference/errors
    public var localizedDescription: String {
        switch self {
        case .invalidRequestError:
            return "There was an issue with the format or content of your request."
        case .authenticationError:
            return "There's an issue with your API key."
        case .permissionError:
            return "Your API key does not have permission to use the specified resource."
        case .notFoundError:
            return "The requested resource was not found."
        case .rateLimitError:
            return "Your account has hit a rate limit."
        case .apiError:
            return "An unexpected error has occurred internal to Anthropic's systems."
        case .overloadedError:
            return "Anthropic's API is temporarily overloaded."
        case .unknown:
            return "Unknown status code from Anthropic's API. There is no document."
        }
    }

    init(fromHttpStatusCode statusCode: Int) {
        switch statusCode {
        case 400:
            self = .invalidRequestError
        case 401:
            self = .authenticationError
        case 403:
            self = .permissionError
        case 404:
            self = .notFoundError
        case 429:
            self = .rateLimitError
        case 500:
            self = .apiError
        case 529:
            self = .overloadedError
        default:
            self = .unknown
        }
    }
}
