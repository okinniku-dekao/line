#!/bin/bash

# プロジェクト名を引数から取得、もしくはカレントディレクトリから推測
if [ $# -eq 0 ]; then
    # カレントディレクトリの.xcodeprojファイルからプロジェクト名を取得
    PROJECT_NAME=$(ls *.xcodeproj | sed 's/\.xcodeproj//')
    if [ -z "$PROJECT_NAME" ]; then
        echo "使用方法: $0 [プロジェクト名]"
        echo "もしくは.xcodeprojファイルが存在するディレクトリで実行してください"
        exit 1
    fi
else
    PROJECT_NAME=$1
fi

echo "プロジェクト名: $PROJECT_NAME"

# プロジェクトルートの不要なファイルを削除
rm -f $PROJECT_NAME/ContentView.swift
rm -f $PROJECT_NAME/${PROJECT_NAME}App.swift

# 基本ディレクトリ構造を作成
mkdir -p $PROJECT_NAME/{App,Sources,Preview\ Content/Preview\ Assets.xcassets}
mkdir -p $PROJECT_NAME/Sources/{Domain,Presentation,Application,Infrastructure}/{Sources,Tests}
# Domain
mkdir -p $PROJECT_NAME/Sources/Domain/Sources/Domain
mkdir -p $PROJECT_NAME/Sources/Domain/Tests/DomainTests
# Presentation
mkdir -p $PROJECT_NAME/Sources/Presentation/Sources/Presentation
mkdir -p $PROJECT_NAME/Sources/Presentation/Tests/PresentationTests
# Application
mkdir -p $PROJECT_NAME/Sources/Application/Sources/Application
mkdir -p $PROJECT_NAME/Sources/Application/Tests/ApplicationTests
# Infrastructure
mkdir -p $PROJECT_NAME/Sources/Infrastructure/Sources/Infrastructure
mkdir -p $PROJECT_NAME/Sources/Infrastructure/Tests/InfrastructureTests

# App/AppNameApp.swiftを作成
cat > $PROJECT_NAME/App/${PROJECT_NAME}App.swift << EOL
import SwiftUI
import Presentation

@main
struct ${PROJECT_NAME}App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOL

# Domain.swiftを作成
cat > $PROJECT_NAME/Sources/Domain/Sources/Domain/Domain.swift << EOL
import Foundation

public struct Domain {
    public init() {}
}
EOL

# DomainTests.swiftを作成
cat > $PROJECT_NAME/Sources/Domain/Tests/DomainTests/DomainTests.swift << EOL
import XCTest
@testable import Domain

final class DomainTests: XCTestCase {
    func testExample() throws {
        XCTAssertNotNil(Domain())
    }
}
EOL

# Application.swiftを作成
cat > $PROJECT_NAME/Sources/Application/Sources/Application/Application.swift << EOL
import Foundation

public struct Application {
    public init() {}
}
EOL

# ApplicationTests.swiftを作成
cat > $PROJECT_NAME/Sources/Application/Tests/ApplicationTests/ApplicationTests.swift << EOL
import XCTest
@testable import Application

final class ApplicationTests: XCTestCase {
    func testExample() throws {
        XCTAssertNotNil(Application())
    }
}
EOL

# Infrastructure.swiftを作成
cat > $PROJECT_NAME/Sources/Infrastructure/Sources/Infrastructure/Infrastructure.swift << EOL
import Foundation

public struct Infrastructure {
    public init() {}
}
EOL     

# InfrastructureTests.swiftを作成
cat > $PROJECT_NAME/Sources/Infrastructure/Tests/InfrastructureTests/InfrastructureTests.swift << EOL
import XCTest
@testable import Infrastructure

final class InfrastructureTests: XCTestCase {
    func testExample() throws {
        XCTAssertNotNil(Infrastructure())
    }
}
EOL


# ContentView.swiftを作成
cat > $PROJECT_NAME/Sources/Presentation/Sources/Presentation/ContentView.swift << EOL
import SwiftUI
import Domain

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        Text("Hello, Clean Architecture!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
EOL

# PresentationTests.swiftを作成
cat > $PROJECT_NAME/Sources/Presentation/Tests/PresentationTests/PresentationTests.swift << EOL
import XCTest
@testable import Presentation

final class PresentationTests: XCTestCase {
    func testExample() throws {
        XCTAssertNotNil(ContentView())
    }
}
EOL

# Domain Package.swiftを作成
cat > $PROJECT_NAME/Sources/Domain/Package.swift << EOL
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
EOL

# Application Package.swiftを作成
cat > $PROJECT_NAME/Sources/Application/Package.swift << EOL
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Application",
    platforms: [.iOS(.v14)],
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
    ]
)
EOL

# Infrastructure Package.swiftを作成
cat > $PROJECT_NAME/Sources/Infrastructure/Package.swift << EOL 
// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.iOS(.v14)],    
    products: [
        .library(name: "Infrastructure", targets: ["Infrastructure"])
    ],
    dependencies: [
        .package(path: "../Domain")
    ],  
    targets: [
        .target(
            name: "Infrastructure",
            dependencies: ["Domain"],
            path: "Sources/Infrastructure"
        ),  
        .testTarget(
            name: "InfrastructureTests",
            dependencies: ["Infrastructure"],
            path: "Tests/InfrastructureTests"
        )
    ]
)
EOL

# Presentation Package.swiftを作成
cat > $PROJECT_NAME/Sources/Presentation/Package.swift << EOL
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
EOL

# Assets.xcassetsの基本構造を作成
mkdir -p $PROJECT_NAME/Assets.xcassets/{AccentColor.colorset,AppIcon.appiconset}

# Contents.jsonファイルを作成
cat > $PROJECT_NAME/Assets.xcassets/Contents.json << EOL
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOL

# AccentColor.colorsetのContents.jsonを作成
cat > $PROJECT_NAME/Assets.xcassets/AccentColor.colorset/Contents.json << EOL
{
  "colors" : [
    {
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOL

# AppIcon.appiconsetのContents.jsonを作成
cat > $PROJECT_NAME/Assets.xcassets/AppIcon.appiconset/Contents.json << EOL
{
  "images" : [],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOL

# Preview Assets.xcassetsのContents.jsonを作成
cat > $PROJECT_NAME/Preview\ Content/Preview\ Assets.xcassets/Contents.json << EOL
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOL

echo "モジュラー構造を $PROJECT_NAME に作成しました"
echo ""
echo "次のステップ:"
echo "1. Xcodeでプロジェクトを開く"
echo "2. File > Add Packages から以下のローカルパッケージを追加:"
echo "   - $(pwd)/$PROJECT_NAME/Sources/Domain"
echo "   - $(pwd)/$PROJECT_NAME/Sources/Presentation"
echo ""
echo "3. ビルドして動作確認"
echo "   もし'No such module' エラーが出る場合は、Xcode > File > Packages > Reset Package Caches を試してください"