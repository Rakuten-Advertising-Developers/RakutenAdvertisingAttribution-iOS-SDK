// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RakutenAdvertisingAttribution",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "RakutenAdvertisingAttribution",
            targets: ["RakutenAdvertisingAttribution"]),
    ],
    dependencies: [
        .package(
            name: "SwiftJWT",
            url: "https://github.com/Kitura/Swift-JWT.git",
            .upToNextMinor(from: "3.6.1"))
    ],
    targets: [
        .target(
            name: "RakutenAdvertisingAttribution",
            dependencies: ["SwiftJWT"],
            path: "RakutenAdvertisingAttribution/Source"),
        .testTarget(
            name: "RakutenAdvertisingAttributionTests",
            dependencies: ["RakutenAdvertisingAttribution"],
            path: "RakutenAdvertisingAttribution/Tests"),
    ]
)
