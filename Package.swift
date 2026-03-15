// swift-tools-version: 5.9

import PackageDescription

let android = Context.environment["TARGET_OS_ANDROID"] ?? "0" != "0"

let package = Package(
    name: "skip-fuse",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipFuse", type: .dynamic, targets: ["SkipFuse"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip-bridge.git", "0.0.0"..<"2.0.0"),
        .package(url: "https://source.skip.tools/swift-jni.git", "0.0.0"..<"2.0.0"),
    ] + (android ? [
        .package(url: "https://source.skip.tools/skip-android-bridge.git", "0.0.0"..<"2.0.0"),
    ] : []),
    targets: [
        .target(name: "SkipFuse", dependencies: [
            .product(name: "SkipBridge", package: "skip-bridge"),
            // we should be getting this transitively through SkipAndroidBridge, but linker errors arise with "Undefined symbol"
            .product(name: "SwiftJNI", package: "swift-jni"),
        ] + (android ? [
            .product(name: "SkipAndroidBridge", package: "skip-android-bridge"),
        ] : [])),
        .testTarget(name: "SkipFuseTests", dependencies: ["SkipFuse"]),
    ]
)
