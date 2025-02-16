// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Presentation", targets: ["Presentation"])
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: ["Domain"],
            path: "Sources/Presentation"
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"],
            path: "Tests/PresentationTests"
        )
    ]
)
