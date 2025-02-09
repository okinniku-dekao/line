#!/bin/bash

# プロジェクト名を引数から取得
if [ $# -eq 0 ]; then
    echo "使用方法: $0 プロジェクト名"
    exit 1
fi

PROJECT_NAME=$1

# Features ディレクトリ構造を作成
mkdir -p Features/{Domain,Data,Presentation}/{Sources,Tests}
mkdir -p Features/Domain/Sources/{Entities,UseCases,Interfaces}
mkdir -p Features/Data/Sources/{Repositories,DataSources,DTOs}
mkdir -p Features/Presentation/Sources/{ViewModels,Views}

# Common ディレクトリ構造を作成
mkdir -p Common/{Networking,Core}/{Sources,Tests}

# 既存のContentView.swiftをPresentationレイヤーに移動するための一時ファイル作成
cat > Features/Presentation/Sources/Views/RootView.swift << EOL
import SwiftUI

struct RootView: View {
    var body: some View {
        Text("Hello, Clean Architecture!")
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
EOL

# 新しいContentView.swiftを作成
cat > ContentView.swift << EOL
import SwiftUI
import Presentation

struct ContentView: View {
    var body: some View {
        RootView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
EOL

# Package.swift ファイルを作成
# Domain
cat > Features/Domain/Package.swift << EOL
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Domain", targets: ["Domain"])
    ],
    dependencies: [
        .package(path: "../../Common/Core")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                .product(name: "Core", package: "Core")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            path: "Tests"
        )
    ]
)
EOL

# Data
cat > Features/Data/Package.swift << EOL
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Data", targets: ["Data"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../../Common/Networking")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Networking", package: "Networking")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"],
            path: "Tests"
        )
    ]
)
EOL

# Presentation
cat > Features/Presentation/Package.swift << EOL
// swift-tools-version:6.0
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
            dependencies: [
                .product(name: "Domain", package: "Domain")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"],
            path: "Tests"
        )
    ]
)
EOL

# Common Packages
for package in Core Networking; do
cat > Common/$package/Package.swift << EOL
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "$package",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "$package", targets: ["$package"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "$package",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "${package}Tests",
            dependencies: ["$package"],
            path: "Tests"
        )
    ]
)
EOL
done

# gitignore ファイルを作成
cat > .gitignore << EOL
.DS_Store
/.build
/Packages
/*.xcodeproj
xcuserdata/
DerivedData/
.swiftpm/config/registries.json
.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata
.netrc
EOL

echo "クリーンアーキテクチャの構造を $PROJECT_NAME に追加しました"
echo "次のステップ:"
echo "1. Xcodeでプロジェクトを開く"
echo "2. File > Add Packages から以下のローカルパッケージを追加:"
echo "   - Features/Domain"
echo "   - Features/Data"
echo "   - Features/Presentation"
echo "   - Common/Core"
echo "   - Common/Networking"
echo "3. ContentView.swiftの import Presentation が解決されることを確認"