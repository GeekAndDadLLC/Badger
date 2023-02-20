// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Badger",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        .executableTarget(
            name: "Badger",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "BadgerTests",
            dependencies: ["Badger"]),
    ]
)
