// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CometChatBuilder",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CometChatBuilder",
            targets: ["CometChatBuilder"]
        )
    ],
    targets: [
        .target(
            name: "CometChatBuilder",
            path: "Sources/CometChatBuilder",
            resources: [
                .process("../../Resources/CometChatBuilderAssets.xcassets")
            ]
        )
    ]
)
