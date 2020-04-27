// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chameleon",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/http.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/url-encoded-form.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "Chameleon", dependencies: ["ChameleonKit", "VaporProviders"]),
        .target(name: "ChameleonKit", dependencies: []),
        .target(name: "VaporProviders", dependencies: ["ChameleonKit", "Vapor", "URLEncodedForm"]),
        .testTarget(name: "ChameleonKitTests", dependencies: ["ChameleonKit"]),
    ]
)

//
// <a href="https://slack.com/oauth/v2/authorize?scope=<scopes>&client_id=<client_id>">Install SlackBot</a>
//
