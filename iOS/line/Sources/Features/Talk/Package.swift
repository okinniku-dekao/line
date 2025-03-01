// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TalkFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "TalkFeature", targets: ["TalkFeature"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.17.1"
        )
    ],
    targets: [
        .target(
            name: "TalkFeature",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .testTarget(
            name: "TalkFeatureTests",
            dependencies: ["TalkFeature"]
        ),
    ]
)
