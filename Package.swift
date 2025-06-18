// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnthropicSwiftSDK",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AnthropicSwiftSDK",
            targets: ["AnthropicSwiftSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/fumito-ito/SwiftyJSONLines.git", from: "0.0.4"),
        .package(url: "https://github.com/fumito-ito/AsyncHTTPKit.git", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AnthropicSwiftSDK",
            dependencies: [
                .product(name: "SwiftyJSONLines", package: "SwiftyJSONLines"),
                .product(name: "AsyncHTTPKit", package: "AsyncHTTPKit")
            ]
        ),
        .testTarget(
            name: "AnthropicSwiftSDKTests",
            dependencies: [
                "AnthropicSwiftSDK",
                "AnthropicSwiftSDK-TestUtils"
            ]),
        .target(
            name: "AnthropicSwiftSDK-TestUtils",
            dependencies: ["AnthropicSwiftSDK"]
        )
    ]
)
