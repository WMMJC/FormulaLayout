// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "FormulaLayout",
    platforms: [
            .iOS(.v9),
            .macOS(.v10_11)
    ],
    products: [
        .library(name: "FormulaLayout", targets: ["FormulaLayout"]),
    ],
    targets: [
        .target(name: "FormulaLayout", path: "Sources"),
        .testTarget(name: "FormulaLayoutTests",dependencies: ["FormulaLayout"],path: "Tests"),
    ]
)
