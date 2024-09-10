// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnthropicSwiftSDK",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AnthropicSwiftSDK",
            targets: ["AnthropicSwiftSDK"]),
        .library(
            name: "AnthropicSwiftSDK-Bedrock",
            targets: ["AnthropicSwiftSDK-Bedrock"]),
        .library(
            name: "AnthropicSwiftSDK-VertexAI",
            targets: ["AnthropicSwiftSDK-VertexAI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "0.76.0"),
        .package(url: "https://github.com/fumito-ito/FunctionCalling", from: "0.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AnthropicSwiftSDK",
            dependencies: [
                .product(name: "FunctionCalling", package: "FunctionCalling")
            ]
        ),
        .testTarget(
            name: "AnthropicSwiftSDKTests",
            dependencies: [
                "AnthropicSwiftSDK",
                "AnthropicSwiftSDK-TestUtils"
            ]),
        .target(
            name: "AnthropicSwiftSDK-Bedrock",
            dependencies: [
                "AnthropicSwiftSDK",
                .product(name: "AWSBedrockRuntime", package: "aws-sdk-swift")
            ]),
        .testTarget(
            name: "AnthropicSwiftSDK-BedrockTests",
            dependencies: [
                "AnthropicSwiftSDK-Bedrock"
            ]),
        .target(
            name: "AnthropicSwiftSDK-VertexAI",
            dependencies: [
                "AnthropicSwiftSDK",
            ]),
        .testTarget(
            name: "AnthropicSwiftSDK-VertexAITests",
            dependencies: [
                "AnthropicSwiftSDK-VertexAI",
                "AnthropicSwiftSDK-TestUtils",
            ]),
        .target(
            name: "AnthropicSwiftSDK-TestUtils",
            dependencies: ["AnthropicSwiftSDK"]
        )
    ]
)
