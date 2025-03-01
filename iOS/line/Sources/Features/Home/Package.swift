// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HomeFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "HomeFeature", targets: ["HomeFeature"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.17.1"
        )
    ],
    targets: [
        .target(
            name: "HomeFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"]
        ),
    ]
)
