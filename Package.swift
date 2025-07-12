// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "VCB",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "VCB",
            targets: ["VCB"]
        )
    ],
    targets: [
        // Binary targets for .xcframeworks
        .binaryTarget(
            name: "CometChatUIKitSwift",
            path: "Frameworks/CometChatUIKitSwift.xcframework"
        ),
        .binaryTarget(
            name: "CometChatSDK",
            path: "Frameworks/CometChatSDK.xcframework"
        ),
        .binaryTarget(
            name: "CometChatStarscream",
            path: "Frameworks/CometChatStarscream.xcframework"
        ),

        // Your VCB target
        .target(
            name: "VCB",
            dependencies: [
                "CometChatUIKitSwift",
                "CometChatSDK",
                "CometChatStarscream"
            ],
            path: "Sources/VCB",
            resources: [
                .process("../../Resources/VCBAssets.xcassets")
            ]
        )
    ]
)
