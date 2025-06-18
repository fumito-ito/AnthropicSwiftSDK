//
//  HTTPMock.swift
//  
//
//  Created by Fumito Ito on 2024/03/17.
//

import Foundation

public enum MockInspectType {
    case none
    case request((URLRequest) -> Void, String?)
    case requestHeader(([String: String]?) -> Void, String?)
    case response(String)
    case error(String)
}

public class HTTPMock: URLProtocol {
    nonisolated(unsafe) public static var inspectType: MockInspectType = .none

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        if case let .request(inspection, _) = Self.inspectType {
            inspection(request)
        }

        if case let .requestHeader(inspection, _) = Self.inspectType {
            inspection(request.allHTTPHeaderFields)
        }

        if let url = request.url,
           let succeedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/2", headerFields: nil),
           let errorResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: "HTTP/2", headerFields: nil) {

            switch Self.inspectType {
            case .none:
                client?.urlProtocol(self, didReceive: succeedResponse, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: getBasicJSONStringData())
            case .request(_, nil), .requestHeader(_, nil):
                client?.urlProtocol(self, didReceive: succeedResponse, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: getBasicJSONStringData())
            case .request(_, let jsonString), .requestHeader(_, let jsonString):
                client?.urlProtocol(self, didReceive: succeedResponse, cacheStoragePolicy: .notAllowed)
                guard let jsonString, let data = jsonString.data(using: .utf8) else {
                    client?.urlProtocol(self, didLoad: getBasicJSONStringData())
                    return
                }
                client?.urlProtocol(self, didLoad: data)
            case .response(let jsonString):
                client?.urlProtocol(self, didReceive: succeedResponse, cacheStoragePolicy: .notAllowed)
                guard let data = jsonString.data(using: .utf8) else {
                    client?.urlProtocol(self, didLoad: getBasicJSONStringData())
                    return
                }
                client?.urlProtocol(self, didLoad: data)
            case .error(let responseJSON):
                client?.urlProtocol(self, didReceive: errorResponse, cacheStoragePolicy: .notAllowed)
                guard
                    let data = responseJSON.data(using: .utf8) else {
                    client?.urlProtocol(self, didLoad: getBasicJSONStringData())
                    return
                }
                client?.urlProtocol(self, didLoad: data)
            }
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    private func getBasicJSONStringData() -> Data {
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
        return basicResponse.data(using: .utf8)!
    }

    public override func stopLoading() {
    }
}
