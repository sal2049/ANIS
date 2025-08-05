// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ANISmock",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ANISmock",
            targets: ["ANISmock"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "ANISmock",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]),
        .testTarget(
            name: "ANISmockTests",
            dependencies: ["ANISmock"]),
    ]
) 