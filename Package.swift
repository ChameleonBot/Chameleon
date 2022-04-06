// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chameleon",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "Chameleon", targets: ["Chameleon"]),
        .library(name: "ChameleonKit", targets: ["ChameleonKit"]),
        .library(name: "ChameleonTestKit", targets: ["ChameleonTestKit"]),
        .library(name: "VaporProviders", targets: ["VaporProviders"]),
    ],
    dependencies: [
		.package(name: "vapor", url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "Chameleon", dependencies: ["ChameleonKit", "VaporProviders"]),
        .target(name: "ChameleonKit", dependencies: []),
        .target(name: "ChameleonTestKit", dependencies: ["ChameleonKit"]),
        .target(name: "VaporProviders", dependencies: [
			"ChameleonKit",
			.product(name: "Vapor", package: "vapor"),
			.product(name: "Redis", package: "redis"),
		]),
        .testTarget(name: "ChameleonKitTests", dependencies: ["ChameleonTestKit"]),
    ]
)

//
// <a href="https://slack.com/oauth/v2/authorize?scope=<scopes>&client_id=<client_id>">Install SlackBot</a>
//
