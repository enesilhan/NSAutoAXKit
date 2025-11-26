// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSAutoAXKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v13)
    ],
    products: [
        // Runtime library that apps will link against
        .library(
            name: "NSAutoAXKit",
            targets: ["NSAutoAXKit"]
        ),
        // Build tool plugin for automatic generation
        .plugin(
            name: "AutoAXPlugin",
            targets: ["AutoAXPlugin"]
        )
    ],
    dependencies: [
        // SwiftSyntax for accurate Swift source parsing
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "509.0.0"
        )
    ],
    targets: [
        // Runtime module - lightweight API for applying accessibility identifiers
        .target(
            name: "NSAutoAXKit",
            dependencies: [],
            path: "Sources/NSAutoAXKit"
        ),
        
        // Generator tool - CLI that scans Swift sources and generates identifier code
        .executableTarget(
            name: "NSAutoAXGenerator",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax")
            ],
            path: "Sources/NSAutoAXGenerator"
        ),
        
        // Build tool plugin - automatically runs generator during build
        .plugin(
            name: "AutoAXPlugin",
            capability: .buildTool(),
            dependencies: ["NSAutoAXGenerator"]
        ),
        
        // Runtime module tests
        .testTarget(
            name: "NSAutoAXKitTests",
            dependencies: ["NSAutoAXKit"],
            path: "Tests/NSAutoAXKitTests"
        ),
        
        // Generator tests
        .testTarget(
            name: "NSAutoAXGeneratorTests",
            dependencies: ["NSAutoAXGenerator"],
            path: "Tests/NSAutoAXGeneratorTests"
        )
    ]
)

