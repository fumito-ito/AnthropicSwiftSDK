//
//  MessagesRequestTests.swift
//  AnthropicSwiftSDK
//
//  Created by 伊藤史 on 2024/10/22.
//

import XCTest
@testable import AnthropicSwiftSDK

final class MessagesRequestTests: XCTestCase {
    func testMessagesRequest() throws {
        let messages = [Message(role: .user, content: [.text("こんにちは")])]
        let systemPrompt: [SystemPrompt] = [.text("あなたは親切なアシスタントです。", .ephemeral)]
        
        let requestBody = MessagesRequestBody(
            model: .claude_3_Opus,
            messages: messages,
            system: systemPrompt,
            maxTokens: 100,
            metaData: MetaData(userId: "test-user"),
            stopSequences: ["END"],
            stream: false,
            temperature: 0.7,
            topP: 0.9,
            topK: 10,
            tools: nil,
            toolChoice: .auto
        )
        
        let request = MessagesRequest(body: requestBody)
        
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.path, RequestType.messages.basePath)
        XCTAssertNil(request.queries)
        
        XCTAssertEqual(request.body?.model.stringfy, Model.claude_3_Opus.stringfy)
        XCTAssertEqual(request.body?.messages.count, 1)
        XCTAssertEqual(request.body?.messages[0].role.rawValue, "user")
        let content1 = try XCTUnwrap(request.body?.messages[0].content)
        guard case let .text(text1) = content1[0] else {
            XCTFail("content1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "こんにちは")
        let system1 = try XCTUnwrap(request.body?.system)
        guard case let .text(text1, _) = system1[0] else {
            XCTFail("system1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "あなたは親切なアシスタントです。")
        XCTAssertEqual(request.body?.maxTokens, 100)
        XCTAssertEqual(request.body?.metaData?.userId, "test-user")
        XCTAssertEqual(request.body?.stopSequences, ["END"])
        XCTAssertFalse(request.body?.stream ?? true)
        XCTAssertEqual(request.body?.temperature, 0.7)
        XCTAssertEqual(request.body?.topP, 0.9)
        XCTAssertEqual(request.body?.topK, 10)
        XCTAssertNil(request.body?.tools)
        XCTAssertNil(request.body?.toolChoice)
    }
    
    func testMessagesRequestWithBatchParameter() throws {
        let messages = [Message(role: .user, content: [.text("こんにちは")])]
        let systemPrompt: [SystemPrompt] = [.text("あなたは親切なアシスタントです。", .ephemeral)]
        
        let batchParameter = BatchParameter(
            messages: messages,
            model: .claude_3_Opus,
            system: systemPrompt,
            maxTokens: 100,
            metaData: MetaData(userId: "test-user"),
            stopSequence: ["END"],
            temperature: 0.7,
            topP: 0.9,
            topK: 10,
            tools: nil,
            toolChoice: .auto
        )
        
        let requestBody = MessagesRequestBody(from: batchParameter)
        let request = MessagesRequest(body: requestBody)
        
        XCTAssertEqual(request.body?.model.stringfy, Model.claude_3_Opus.stringfy)
        XCTAssertEqual(request.body?.messages.count, 1)
        XCTAssertEqual(request.body?.messages[0].role.rawValue, "user")
        let content1 = try XCTUnwrap(request.body?.messages[0].content)
        guard case let .text(text1) = content1[0] else {
            XCTFail("content1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "こんにちは")
        let system1 = try XCTUnwrap(request.body?.system)
        guard case let .text(text1, _) = system1[0] else {
            XCTFail("system1[0] is not .text")
            return
        }
        XCTAssertEqual(text1, "あなたは親切なアシスタントです。")
        XCTAssertEqual(request.body?.maxTokens, 100)
        XCTAssertEqual(request.body?.metaData?.userId, "test-user")
        XCTAssertEqual(request.body?.stopSequences, ["END"])
        XCTAssertFalse(request.body?.stream ?? true)
        XCTAssertEqual(request.body?.temperature, 0.7)
        XCTAssertEqual(request.body?.topP, 0.9)
        XCTAssertEqual(request.body?.topK, 10)
        XCTAssertNil(request.body?.tools)
        XCTAssertNil(request.body?.toolChoice)
    }

    func testEncoding() throws {
        // Prepare test data
        let message = Message(role: .user, content: [.text("Hello")])
        let systemPrompt: SystemPrompt = .text("You are a helpful assistant", nil)

        // Define various tools for testing
        let tools = [
            // Computer tool
            Tool.computer(.init(
                name: "computer",
                displayWidthPx: 1024,
                displayHeightPx: 768,
                displayNumber: 1
            )),

            // Text editor tool
            Tool.textEditor(.init(
                name: "str_replace_editor"
            )),

            // Bash tool
            Tool.bash(.init(
                name: "bash"
            )),

            // Function tool (weather)
            Tool.function(.init(
                name: "get_weather",
                description: "Get weather information",
                inputSchema: .init(
                    type: .object,
                    format: nil,
                    description: "Weather query parameters",
                    nullable: nil,
                    enumValues: nil,
                    items: nil,
                    properties: [
                        "location": .init(
                            type: .string,
                            format: nil,
                            description: "City name",
                            nullable: nil,
                            enumValues: nil,
                            items: nil,
                            properties: nil,
                            requiredProperties: nil
                        )
                    ],
                    requiredProperties: ["location"]
                )
            ))
        ]

        let sut = MessagesRequestBody(
            model: .claude_3_Opus,
            messages: [message],
            system: [systemPrompt],
            maxTokens: 1000,
            metaData: .init(userId: "test-user"),
            stopSequences: ["STOP"],
            stream: true,
            temperature: 0.7,
            topP: 0.9,
            topK: 10,
            tools: tools,
            toolChoice: .auto
        )

        // Encode to JSON
        let data = try anthropicJSONEncoder.encode(sut)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        // Verify basic properties
        XCTAssertEqual(json["model"] as? String, "claude-3-opus-20240229")
        XCTAssertEqual((json["messages"] as? [[String: Any]])?.count, 1)
        XCTAssertEqual((json["system"] as? [[String: Any]])?.count, 1)
        XCTAssertEqual(json["max_tokens"] as? Int, 1000)
        XCTAssertNotNil(json["meta_data"])
        XCTAssertEqual((json["stop_sequences"] as? [String]), ["STOP"])
        XCTAssertEqual(json["stream"] as? Bool, true)
        XCTAssertEqual(json["temperature"] as? Double, 0.7)
        XCTAssertEqual(json["top_p"] as? Double, 0.9)
        XCTAssertEqual(json["top_k"] as? Int, 10)

        // Verify tools array
        let encodedTools = json["tools"] as? [[String: Any]]
        XCTAssertEqual(encodedTools?.count, 4)

        // Verify computer tool
        let computerTool = encodedTools?[0]
        XCTAssertEqual(computerTool?["type"] as? String, "computer_20241022")
        XCTAssertEqual(computerTool?["name"] as? String, "computer")
        XCTAssertEqual(computerTool?["display_width_px"] as? Int, 1024)
        XCTAssertEqual(computerTool?["display_height_px"] as? Int, 768)

        // Verify text editor tool
        let textEditorTool = encodedTools?[1]
        XCTAssertEqual(textEditorTool?["type"] as? String, "textEditor_20241022")
        XCTAssertEqual(textEditorTool?["name"] as? String, "str_replace_editor")

        // Verify bash tool
        let bashTool = encodedTools?[2]
        XCTAssertEqual(bashTool?["type"] as? String, "bash_20241022")
        XCTAssertEqual(bashTool?["name"] as? String, "bash")

        // Verify function tool
        let functionTool = encodedTools?[3]
        XCTAssertEqual(functionTool?["name"] as? String, "get_weather")
        XCTAssertNotNil(functionTool?["description"])
        XCTAssertNotNil(functionTool?["input_schema"])

        XCTAssertNotNil(json["tool_choice"])
    }

    func testEncodingWithMinimalParameters() throws {
        // Test with only required parameters
        let message = Message(role: .user, content: [.text("Hello")])
        let sut = MessagesRequestBody(
            messages: [message],
            maxTokens: 1000
        )

        let data = try anthropicJSONEncoder.encode(sut)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        // Verify minimal configuration
        XCTAssertEqual(json["model"] as? String, "claude-3-opus-20240229")
        XCTAssertEqual((json["messages"] as? [[String: Any]])?.count, 1)
        XCTAssertEqual(json["max_tokens"] as? Int, 1000)
        XCTAssertNil(json["tool_choice"])
    }
}
