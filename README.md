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
        .package(url: "https://github.com/fumito-ito/AnthropicSwiftSDK.git", .upToNextMajor(from: "0.11.0"))
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

AnthropicSwiftSDK supports `Tool Use` in conjunction with the [`@FunctionCalling`](https://github.com/fumito-ito/FunctionCalling) macro and [FunctionCalling-AnthropicSwiftSDK](https://github.com/FunctionCalling/FunctionCalling-AnthropicSwiftSDK.git) extension. You can easily handle `Tool Use` with the following code.

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
        tools: MyFunctionTools().anthropicSwiftTools // <= pass tool container here
    )
```

### [Prompt Caching (beta)](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)

Prompt caching is a powerful feature that optimizes your API usage by allowing resuming from specific prefixes in your prompts.

You can cache large text content, e.g. “Pride and Prejudice”,  using the cache_control parameter. This enables reuse of this large text across multiple API calls without reprocessing it each time. Changing only the user message allows you to ask various questions about the book while utilizing the cached content, leading to faster responses and improved efficiency.

Here’s an example of how to implement prompt caching with the Messages API using a cache_control block:

```swift
let anthropic = Anthropic(apiKey: "YOUR_OWN_API_KEY")

let message = Message(role: .user, content: [.text("Analyze the major themes in Pride and Prejudice.")])
let response = try await anthropic.messages.createMessage(
    [message],
    system: [
        .text("You are an AI assistant tasked with analyzing literary works. Your goal is to provide insightful commentary on themes, characters, and writing style.\n", nil),
        .text("<the entire contents of Pride and Prejudice>", .ephemeral)
    ],
    maxTokens: 1024
)
```

### [Message Batches (beta)](https://docs.anthropic.com/en/docs/build-with-claude/message-batches)

The Message Batches API is a powerful, cost-effective way to asynchronously process large volumes of [Messages](https://docs.anthropic.com/en/api/messages) requests. This approach is well-suited to tasks that do not require immediate responses, reducing costs by 50% while increasing throughput.

This is especially useful for bulk operations that don’t require immediate results.

Here's an example of how to process many messages with the Message Bathches API:

```swift
let anthropic = Anthropic(apiKey: "YOUR_OWN_API_KEY")

let messages = [
    Message(role: .user, content: [.text("Write a haiku about robots.")]),
    Message(role: .user, content: [.text("Write a haiku about robots. Skip the preamble; go straight into the poem.")]),
    Message(role: .user, content: [.text("Who is the best basketball player of all time?")]),
    Message(role: .user, content: [.text("Who is the best basketball player of all time? Yes, there are differing opinions, but if you absolutely had to pick one player, who would it be?")])
    // ....
]

let batch = MessageBatch(
    customId: "my-first-batch-request",
    parameter: .init(
        messages: messages,
        maxTokens: 1024
    )
)

let response = try await anthropic.messageBatches.createBatches(batches: [batch])
```

### [Computer Use (beta)](https://docs.anthropic.com/en/docs/build-with-claude/computer-use#computer-tool)

The upgraded Claude 3.5 Sonnet model is capable of interacting with tools that can manipulate a computer desktop environment.

By implementing the following code, you can instruct Claude to return commands for executing tasks on a computer

```swift
let anthropic = Anthropic(apiKey: "YOUR_OWN_API_KEY")

let message = Message(role: .user, content: [.text("Find flights from San Francisco to a place with warmer weather.")])
let response = try await anthropic.messages.createMessage(
    [message],
    maxTokens: 1024,
    tools: [
        .computer(.init(name: "my_computer", displayWidthPx: 1024, displayHeightPx: 768, displayNumber: 1),
        .bash(.init(name: "bash"))
    ]
)
```

### [Token Counting](https://docs.anthropic.com/en/docs/build-with-claude/token-counting)

Token counting enables you to determine the number of tokens in a message before sending it to Claude, helping you make informed decisions about your prompts and usage. With token counting, you can

- Proactively manage rate limits and costs
- Make smart model routing decisions
- Optimize prompts to be a specific length

```swift
let anthropic = Anthropic(apiKey: "YOUR_OWN_API_KEY")

let message = Message(role: .user, content: [.text("Find flights from San Francisco to a place with warmer weather.")])
let response = try await anthropic.countTokens.countTokens(
    [message],
    maxTokens: 1024,
    tools: [
        .computer(.init(name: "my_computer", displayWidthPx: 1024, displayHeightPx: 768, displayNumber: 1),
        .bash(.init(name: "bash"))
    ]
)
```

The token counting endpoint accepts the same structured list of inputs for creating a message, including support for system prompts, tools, images, and PDFs. The response contains the total number of input tokens.

## Extensions

By introducing an extension Swift package, it is possible to access the Anthropic Claude API through AWS Bedrock and Vertex AI. The supported services are as follows:

- [Amazon Web Services Bedrock](https://github.com/fumito-ito/AnthropicSwiftSDK-Bedrock)
- [Google VertexAI](https://github.com/fumito-ito/AnthropicSwiftSDK-VertexAI)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
