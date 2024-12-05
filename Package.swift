// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkPackage",
    products: [
        .library(
            name: "NetworkPackage",
            targets: ["NetworkPackage"]),
    ],
    dependencies: [
         .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
     ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkPackage",
        dependencies: [
            .product(name: "KeychainSwift", package: "keychain-swift")
        ]),
    ]
)
