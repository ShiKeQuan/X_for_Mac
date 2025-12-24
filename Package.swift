// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "X_for_mac",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "X_for_mac",
            targets: ["X_for_mac"]
        )
    ],
    targets: [
        .executableTarget(
            name: "X_for_mac"
        )
    ]
)
