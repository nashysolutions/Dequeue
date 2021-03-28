// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dequeue",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Dequeue",
            targets: ["Dequeue"]),
    ],
    targets: [
        .target(
            name: "Dequeue",
            dependencies: []),
        .testTarget(
            name: "DequeueTests",
            dependencies: ["Dequeue"]),
    ]
)
