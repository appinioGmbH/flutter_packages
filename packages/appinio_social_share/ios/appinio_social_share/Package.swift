// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "appinio_social_share",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "appinio-social-share", targets: ["appinio_social_share"])
    ],
    dependencies: [
        // Mirrors the CocoaPods dependency on FBSDKCoreKit / FBSDKShareKit 17.0.2.
        .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "17.0.2")
    ],
    targets: [
        .target(
            name: "appinio_social_share",
            dependencies: [
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookShare", package: "facebook-ios-sdk")
            ]
        )
    ]
)
