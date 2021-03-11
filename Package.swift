// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Tap",
    products: [

        .library(
            name: "Tap",
            targets: ["Tap"]),
    ],
    dependencies: [

    ],
    targets: [
       
        .target(
            name: "Tap",
            dependencies: []),
        .testTarget(
            name: "TapTests",
            dependencies: ["Tap"]),
    ]
)
