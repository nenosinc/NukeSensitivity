// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NukeSensitivity",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NukeSensitivity",
            targets: ["NukeSensitivity"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/nuke", .upToNextMajor(from: "12.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NukeSensitivity",
            dependencies: [
                .product(name: "NukeUI", package: "Nuke"),
            ]
        ),
        .testTarget(
            name: "NukeSensitivityTests",
            dependencies: ["NukeSensitivity"]),
    ]
)
