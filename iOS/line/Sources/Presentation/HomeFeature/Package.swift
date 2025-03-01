// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Home", targets: ["Home"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.1")
    ],
    targets: [
        .target(
            name: "Home",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .testTarget(
            name: "HomeTests",
            dependencies: ["Home"]
        ),
    ]
)
