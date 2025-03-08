// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AppRootFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppRootFeature", targets: ["AppRootFeature"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.17.1"
        ),
        .package(path: "../MainTabBarFeature")
    ],
    targets: [
        .target(
            name: "AppRootFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                "MainTabBarFeature"
            ]
        ),
        .testTarget(
            name: "AppRootFeatureTests",
            dependencies: ["AppRootFeature"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
