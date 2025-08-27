// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bitlabs",
    defaultLocalization: "en",
    platforms: [.iOS("12.0")],
    products: [.library(name: "bitlabs", targets: ["bitlabs"])],
    dependencies: [.package(url: "https://github.com/BitBurst-GmbH/bitlabs-ios-sdk.git", revision: "d785e4d3ae432f4bca20a60963c3acd3b15e685c")],
    targets: [
        .target(
            name: "bitlabs",
            dependencies: [.product(name: "BLCustom", package: "bitlabs-ios-sdk")],
        )
    ]
)
