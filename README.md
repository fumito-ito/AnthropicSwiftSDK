# Anthropic Swift SDK

Yet another [Anthropic API](https://www.anthropic.com/api) client for Swift.

## Installation

### Swift Package Manager

Just add to your Package.swift under dependencies

```swift
let package = Package(
    name: "MyPackage",
    products: [...],
    targets: [
        .target(
            "YouAppModule",
            dependencies: [
                .product(name: "AnthropicSwiftSDK", package: "AnthropicSwiftSDK")
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/fumito-ito/AnthropicSwiftSDK.git", .upToNextMajor(from: "0.5.0"))
    ]
)
```

## Usage

```swift
let anthropic = Anthropic(apiKey: "YOUR_OWN_API_KEY")

let message = Message(role: .user, content: [.text("This is test text")])
let response = try await anthropic.messages.createMessage([message], maxTokens: 1024)
```

## Supporting APIs

This library currently supports _Messages API_. If you need legacy _Text Completion API_, please make PRs or Issues.

### [Create a Message API](https://docs.anthropic.com/claude/reference/messages_post)

Send a structured list of input messages with text and/or image content, and the model will generate the next message in the conversation.

The Messages API can be used for for either single queries or stateless multi-turn conversations.

```swift
let anthropic = Anthropic(apiKey: "YOUR_OWN_API_KEY")

let message = Message(role: .user, content: [.text("This is test text")])
let response = try await anthropic.messages.createMessage([message], maxTokens: 1024)

for content in response.content {
    switch content {
    case .text(let text):
        print(text)
    case .image(let imageContent):
        // handle base64 encoded image content
    }
}
```

### [Streaming Message API](https://docs.anthropic.com/claude/reference/messages-streaming)

Send a structured list of input messages with text and/or image content, and the model will generate incrementally stream the response using server-sent events (SSE).

```swift
let anthropic = Anthropic(apiKey: "YOUR_OWN_API_KEY")

let message = Message(role: .user, content: [.text("This is test text")])
let stream = try await anthropic.messages.streamMessage([message], maxTokens: 1024)

for try await chunk in stream {
    switch chunk.type {
    case .messageStart:
        // handle message start object with casting chunk into `StreamingMessageStartResponse`
    }
}
```

### [Tool Use](https://docs.anthropic.com/en/docs/build-with-claude/tool-use)

Claude is capable of interacting with external client-side tools and functions, allowing you to equip Claude with your own custom tools to perform a wider variety of tasks.

AnthropicSwiftSDK supports `Tool Use` in conjunction with the [`@FunctionCalling`](https://github.com/fumito-ito/FunctionCalling) macro. You can easily handle `Tool Use` with the following code.

```swift
@FunctionCalling(service: .claude)
struct MyFunctionTools: ToolContainer {
    @CallableFunction
    /// Get the current stock price for a given ticker symbol
    ///
    /// - Parameter: The stock ticker symbol, e.g. AAPL for Apple Inc.
    func getStockPrice(ticker: String) async throws -> String {
        // code to return stock price of passed ticker
    }
}


let result = try await Anthropic(apiKey: "your_claude_api_key")
    .createMessage(
        [message],
        maxTokens: 1024,
        toolContainer: MyFunctionTools() // <= pass tool container here
    )
```

## Extensions

By introducing an extension Swift package, it is possible to access the Anthropic Claude API through AWS Bedrock and Vertex AI. The supported services are as follows:

- [Amazon Web Services Bedrock](https://github.com/fumito-ito/AnthropicSwiftSDK-Bedrock)
- VertexAI
    - T.B.D.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
