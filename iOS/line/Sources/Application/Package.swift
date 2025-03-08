// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Application",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Application", targets: ["Application"])
    ],
    dependencies: [
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Application",    
            dependencies: ["Domain"],
            path: "Sources/Application"
        ),
        .testTarget(
            name: "ApplicationTests",
            dependencies: ["Application"],  
            path: "Tests/ApplicationTests"
        )
    ],
    swiftLanguageModes: [.v6]
)
