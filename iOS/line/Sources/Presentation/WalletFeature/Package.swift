// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WalletFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "WalletFeature", targets: ["WalletFeature"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.17.1"
        ),
    ],
    targets: [
        .target(
            name: "WalletFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .testTarget(
            name: "WalletFeatureTests",
            dependencies: ["WalletFeature"]
        ),
    ]
)

