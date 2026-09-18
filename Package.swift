// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "HoldToConfirmButton",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "HoldToConfirmButton",
            targets: ["HoldToConfirmButton"]
        )
    ],
    targets: [
        .target(
            name: "HoldToConfirmButton"
        ),
        .testTarget(
            name: "HoldToConfirmButtonTests",
            dependencies: ["HoldToConfirmButton"]
        )
    ]
)
