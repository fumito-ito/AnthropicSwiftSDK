// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Example",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "Example",
            targets: ["AppModule"],
            bundleIdentifier: "com.github.fumito-ito.AnthropicSwiftSDK.Example",
            teamIdentifier: "L8LPZ499U7",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .clock),
            accentColor: .presetColor(.pink),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .outgoingNetworkConnections()
            ]
        )
    ],
    dependencies: [
        .package(path: "..")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "AnthropicSwiftSDK", package: "AnthropicSwiftSDK")
            ],
            path: "."
        )
    ]
)