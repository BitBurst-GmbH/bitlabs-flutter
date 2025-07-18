// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bitlabs",
    defaultLocalization: "en",
    platforms: [.iOS("12.0")],
    products: [.library(name: "bitlabs", targets: ["bitlabs"])],
    dependencies: [.package(url: "https://github.com/BitBurst-GmbH/bitlabs-ios-sdk.git", branch: "blcustom")],
    targets: [
        .target(
            name: "bitlabs",
            dependencies: [.product(name: "BLCustom", package: "bitlabs-ios-sdk")],
        )
    ]
)
