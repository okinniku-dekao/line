// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Domain", targets: ["Domain"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Domain",
            dependencies: [],
            path: "Sources/Domain"
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            path: "Tests/DomainTests"
        )
    ]
)
