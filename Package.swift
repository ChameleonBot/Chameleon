// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chameleon",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "Chameleon", targets: ["Chameleon"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "RTMAPI", targets: ["RTMAPI"]),
        .library(name: "Services", targets: ["Services"]),
        .library(name: "WebAPI", targets: ["WebAPI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/vapor.git", from: "2.4.4"),
        .package(url: "https://github.com/vapor/redis.git", from: "2.0.0"),
    ],
    targets: [
        .target(name: "Chameleon", dependencies: ["Common", "Models", "Services", "RTMAPI", "WebAPI"]),

        .target(name: "Common", dependencies: []),
        .testTarget(name: "CommonTests", dependencies: ["Common"]),

        .target(name: "Models", dependencies: ["Common"]),
        .target(name: "RTMAPI", dependencies: ["Common", "Models", "Services"]),
        .target(name: "Services", dependencies: ["Common", "Vapor", "Redis"]),
        .target(name: "WebAPI", dependencies: ["Common", "Models", "Services"]),
    ]
)
