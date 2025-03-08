// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NewsFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "NewsFeature", targets: ["NewsFeature"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.17.1"
        ),
    ],
    targets: [
        .target(
            name: "NewsFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .testTarget(
            name: "NewsFeatureTests",
            dependencies: ["NewsFeature"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
