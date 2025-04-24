// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ImageLoaderSPM",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ImageLoaderSPM",
            targets: ["ImageLoaderSPM"]
        ),
    ],
    targets: [
        .target(
            name: "ImageLoaderSPM",
            path: "Sources"
        ),
    ]
)
