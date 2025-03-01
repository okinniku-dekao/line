// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MainTabBarFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "MainTabBarFeature", targets: ["MainTabBarFeature"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.17.1"
        ),
    ],
    targets: [
        .target(
            name: "MainTabBarFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .testTarget(
            name: "MainTabBarFeatureTests",
            dependencies: ["MainTabBarFeature"]
        ),
    ]
)
