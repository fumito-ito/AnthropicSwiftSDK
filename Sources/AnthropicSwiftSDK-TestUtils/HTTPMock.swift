//
//  HTTPMock.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public enum MockInspectType {
    case none
    case request((URLRequest) -> Void)
    case requestHeader(([String: String]?) -> Void)
    case response(String)
}

public class HTTPMock: URLProtocol {
    public static var inspectType: MockInspectType = .none

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        if case let .request(inspection) = Self.inspectType {
            inspection(request)
        }

        if case let .requestHeader(inspection) = Self.inspectType {
            inspection(request.allHTTPHeaderFields)
        }

        if let url = request.url,
           let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/2", headerFields: nil) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if case let .response(jsonString) = Self.inspectType,
               let data = jsonString.data(using: .utf8) {
                client?.urlProtocol(self, didLoad: data)
            } else {
                let basicResponse = """
                {
                  "id": "msg_01XFDUDYJgAACzvnptvVoYEL",
                  "type": "message",
                  "role": "assistant",
                  "content": [
                    {
                      "type": "text",
                      "text": "Hello!"
                    }
                  ],
                  "model": "claude-2.1",
                  "stop_reason": "end_turn",
                  "stop_sequence": null,
                  "usage": {
                    "input_tokens": 12,
                    "output_tokens": 6
                  }
                }
                """
                let data = basicResponse.data(using: .utf8)!
                client?.urlProtocol(self, didLoad: data)
            }
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    public override func stopLoading() {
    }
}
