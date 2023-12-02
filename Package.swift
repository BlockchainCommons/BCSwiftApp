// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BCApp",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
    ],
    products: [
        .library(
            name: "BCApp",
            targets: ["BCApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/WolfMcNally/WolfBase", from: "6.0.0"),
        .package(url: "https://github.com/BlockchainCommons/BCSwiftFoundation", from: "10.0.0"),
        .package(url: "https://github.com/BlockchainCommons/LifeHash.git", from: "7.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfSwiftUI.git", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLorem.git", from: "3.0.0"),
        .package(url: "https://github.com/BlockchainCommons/URUI.git", from: "9.0.0"),
        .package(url: "https://github.com/BlockchainCommons/BCSwiftNFC.git", from: "3.0.0"),
        .package(url: "https://github.com/gonzalezreal/MarkdownUI.git", from: "1.1.0"),
        .package(url: "https://github.com/wolfmcnally/UIImageColors.git", from: "3.0.0"),
        .package(url: "https://github.com/globulus/swiftui-flow-layout.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "BCApp",
            dependencies: [
                "WolfBase",
                "LifeHash",
                "WolfSwiftUI",
                "WolfLorem",
                "URUI",
                "MarkdownUI",
                "UIImageColors",
                .product(name: "SwiftUIFlowLayout", package: "swiftui-flow-layout"),
                .product(name: "BCFoundation", package: "BCSwiftFoundation"),
                .product(name: "NFC", package: "BCSwiftNFC"),
            ],
            resources: [
                .copy("Resources/NamedColors.json"),
                .copy("Resources/Sounds"),
                .process("Resources/SharedAssets.xcassets")
            ]
        )
    ]
)
