// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NewFileMenu",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "NewFileMenuShared",
            targets: ["NewFileMenuShared"]
        )
    ],
    targets: [
        .target(
            name: "NewFileMenuShared",
            path: "Shared"
        ),
        .testTarget(
            name: "NewFileMenuSharedTests",
            dependencies: ["NewFileMenuShared"],
            path: "Tests/NewFileMenuSharedTests"
        )
    ]
)
