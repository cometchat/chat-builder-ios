// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "VCB",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "VCB",
            targets: ["VCB"]
        ),
    ],
    targets: [
        .target(
            name: "VCB",
            dependencies: [],
            path: "Sources/VCB",
        )
    ]
)

