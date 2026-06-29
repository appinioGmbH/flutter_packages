// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "disable_screenshot",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "disable-screenshot", targets: ["disable_screenshot"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "disable_screenshot"
        )
    ]
)
