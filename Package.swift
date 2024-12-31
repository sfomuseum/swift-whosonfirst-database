// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhosOnFirst",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WhosOnFirst",
            targets: ["WhosOnFirst"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.3"),
        .package(url: "https://github.com/kiliankoe/GeoJSON.git", from: "0.6.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WhosOnFirst",
            dependencies: [
                .product(name: "SQLite", package: "SQLite.swift"),
                .product(name: "GeoJSON", package: "GeoJSON")
            ]
        ),
        .testTarget(
            name: "WhosOnFirstTests",
            dependencies: ["WhosOnFirst"]
        ),
    ]
)
