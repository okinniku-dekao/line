// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Presentation", targets: ["Presentation"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.1")
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                "Domain",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Presentation"
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"],
            path: "Tests/PresentationTests"
        )
    ]
)
