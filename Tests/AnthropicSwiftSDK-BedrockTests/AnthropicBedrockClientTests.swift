//
//  AnthropicBedrockClientTests.swift
//  
//
//  Created by 伊藤史 on 2024/03/25.
//

import XCTest
@testable import AnthropicSwiftSDK_Bedrock
import AnthropicSwiftSDK
import AWSBedrockRuntime

final class AnthropicBedrockClientTests: XCTestCase {
    func testClientUsePassedAnthropicModel() throws {
        let client = try BedrockRuntimeClient(region: "US")

        var anthropic = BedrockRuntimeClient.useAnthropic(client, model: .claude_3_Haiku)
        XCTAssertEqual(anthropic.messages.model.description, Model.claude_3_Haiku.description)

        anthropic = BedrockRuntimeClient.useAnthropic(client, model: .claude_3_Sonnet)
        XCTAssertEqual(anthropic.messages.model.description, Model.claude_3_Sonnet.description)

        anthropic = BedrockRuntimeClient.useAnthropic(client, model: .claude_3_Opus)
        XCTAssertEqual(anthropic.messages.model.description, Model.claude_3_Opus.description)

        anthropic = BedrockRuntimeClient.useAnthropic(client, model: .claude_3_5_Sonnet)
        XCTAssertEqual(anthropic.messages.model.description, Model.claude_3_5_Sonnet.description)

        anthropic = BedrockRuntimeClient.useAnthropic(client, model: .custom("custom-model"))
        XCTAssertEqual(anthropic.messages.model.description, "custom-model")
    }

    func testInvokeModelContainEncodedMessageRequest() throws {
        let request = MessagesRequest(model: .claude_3_Haiku, messages: [Message(role: .user, content: [.text("Hello! Claude!")])], system: nil, maxTokens: 1024, metaData: MetaData(userId: "112234"), stopSequences: ["stop sequence"], stream: false, temperature: 0.4, topP: 1, topK: 2)
        let invokeModel = try InvokeModelInput(accept: "application/json", request: request, contentType: "application/json")

        let requestData = try XCTUnwrap(invokeModel.body)
        let decodedRequestData = try anthropicJSONDecoder.decode(MessagesRequest.self, from: requestData)

        XCTAssertEqual(request.model.description, decodedRequestData.model.description)
        XCTAssertEqual(request.messages.first?.role, decodedRequestData.messages.first?.role)
        XCTAssertEqual(request.messages.first?.content.first, decodedRequestData.messages.first?.content.first)
        XCTAssertEqual(request.system, decodedRequestData.system)
        XCTAssertEqual(request.maxTokens, decodedRequestData.maxTokens)
        XCTAssertEqual(request.metaData?.userId, decodedRequestData.metaData?.userId)
        XCTAssertEqual(request.stopSequences, decodedRequestData.stopSequences)
        XCTAssertEqual(request.stream, decodedRequestData.stream)
        XCTAssertEqual(request.temperature, decodedRequestData.temperature)
        XCTAssertEqual(request.topP, decodedRequestData.topP)
        XCTAssertEqual(request.topK, decodedRequestData.topK)
    }

    func testInvokeModelWithResponseStreamContainEncodedMessageRequest() throws {
        let request = MessagesRequest(model: .claude_3_Haiku, messages: [Message(role: .user, content: [.text("Hello! Claude!")])], system: nil, maxTokens: 1024, metaData: MetaData(userId: "112234"), stopSequences: ["stop sequence"], stream: false, temperature: 0.4, topP: 1, topK: 2)
        let invokeModel = try InvokeModelWithResponseStreamInput(accept: "application/json", request: request, contentType: "application/json")

        let requestData = try XCTUnwrap(invokeModel.body)
        let decodedRequestData = try anthropicJSONDecoder.decode(MessagesRequest.self, from: requestData)

        XCTAssertEqual(request.model.description, decodedRequestData.model.description)
        XCTAssertEqual(request.messages.first?.role, decodedRequestData.messages.first?.role)
        XCTAssertEqual(request.messages.first?.content.first, decodedRequestData.messages.first?.content.first)
        XCTAssertEqual(request.system, decodedRequestData.system)
        XCTAssertEqual(request.maxTokens, decodedRequestData.maxTokens)
        XCTAssertEqual(request.metaData?.userId, decodedRequestData.metaData?.userId)
        XCTAssertEqual(request.stopSequences, decodedRequestData.stopSequences)
        XCTAssertEqual(request.stream, decodedRequestData.stream)
        XCTAssertEqual(request.temperature, decodedRequestData.temperature)
        XCTAssertEqual(request.topP, decodedRequestData.topP)
        XCTAssertEqual(request.topK, decodedRequestData.topK)
    }

    func testInvokeModelOutputShouldBeConvertToMessageResponse() throws {
        let json = """
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
        let output = InvokeModelOutput(body: json.data(using: .utf8), contentType: "application/json")
        let outputData = try XCTUnwrap(output.body)
        let decodedOutputData = try anthropicJSONDecoder.decode(MessagesResponse.self, from: outputData)

        XCTAssertEqual(decodedOutputData.id, "msg_01XFDUDYJgAACzvnptvVoYEL")
        XCTAssertEqual(decodedOutputData.type, .message)
        XCTAssertEqual(decodedOutputData.role, .assistant)
        XCTAssertEqual(decodedOutputData.content.first, .text("Hello!"))
        XCTAssertEqual(decodedOutputData.model?.description, Model.custom("claude-2.1").description)
        XCTAssertEqual(decodedOutputData.stopReason, .endTurn)
        XCTAssertNil(decodedOutputData.stopSequence)
        XCTAssertEqual(decodedOutputData.usage.inputTokens, 12)
        XCTAssertEqual(decodedOutputData.usage.outputTokens, 6)
    }
}

extension Model {
    var description: String {
        switch self {
        case .claude_3_Opus:
            return "claude_3_Opus"
        case .claude_3_Sonnet:
            return "claude_3_Sonnet"
        case .claude_3_Haiku:
            return "claude_3_Haiku"
        case .claude_3_5_Sonnet:
            return "claude_3_5_Sonnet"
        case .custom(let modelName):
            return modelName
        }
    }
}

extension MetaData: Decodable {
    enum CodingKeys: String, CodingKey {
        case userId
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userId = try container.decode(String.self, forKey: .userId)
        self.init(userId: userId)
    }
}

extension MessagesRequest: Decodable {
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case system
        case maxTokens
        case metaData
        case stopSequences
        case stream
        case temperature
        case topP
        case topK
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            model: try container.decode(Model.self, forKey: .model),
            messages: try container.decode([Message].self, forKey: .messages),
            system: try? container.decode(String.self, forKey: .system),
            maxTokens: try container.decode(Int.self, forKey: .maxTokens),
            metaData: try container.decode(MetaData.self, forKey: .metaData),
            stopSequences: try container.decode([String].self, forKey: .stopSequences),
            stream: try container.decode(Bool.self, forKey: .stream),
            temperature: try container.decode(Double.self, forKey: .temperature),
            topP: try container.decode(Double.self, forKey: .topP),
            topK: try container.decode(Int.self, forKey: .topK)
        )
    }
}

extension Content: Equatable {
    public static func == (lhs: AnthropicSwiftSDK.Content, rhs: AnthropicSwiftSDK.Content) -> Bool {
        switch lhs {
        case .text(let lhsText):
            switch rhs {
            case .text(let rhsText):
                return lhsText == rhsText
            case .image:
                return false
            }
        case .image(let lhsContent):
            switch rhs {
            case .text:
                return false
            case .image(let rhsContent):
                return lhsContent.data == rhsContent.data
            }
        }
    }
}
