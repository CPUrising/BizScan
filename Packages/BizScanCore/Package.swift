// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BizScanCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(name: "BizScanCore", targets: ["BizScanCore"])
    ],
    targets: [
        .target(
            name: "BizScanCore",
            path: "Sources/BizScanCore"
        ),
        .testTarget(
            name: "BizScanCoreTests",
            dependencies: ["BizScanCore"],
            path: "Tests/BizScanCoreTests"
        )
    ]
)
