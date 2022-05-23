// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "BCApp",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "BCApp",
            targets: ["BCApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/WolfMcNally/WolfBase", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "BCApp",
            dependencies: ["WolfBase"]),
        .testTarget(
            name: "BCAppTests",
            dependencies: ["BCApp"]),
    ]
)
