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
        .target(
            name: "VCB",
            path: "Sources/VCB",
            resources: [
                .process("../../Resources/VCBAssets.xcassets")
            ]
        )
    ]
)
