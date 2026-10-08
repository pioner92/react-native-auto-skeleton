// swift-tools-version:5.9
// Unit tests for the architecture-agnostic Swift core in ios/SkeletonView.
// Run with `yarn test:ios`.
import PackageDescription

let package = Package(
  name: "AutoSkeletonNativeTests",
  platforms: [.iOS(.v15)],
  targets: [
    .target(
      name: "SkeletonView",
      path: "Sources/SkeletonView",
      // The Fabric subclass imports React, which is not available outside the app build.
      exclude: ["SkeletonViewFabric.swift"]
    ),
    .testTarget(
      name: "SkeletonViewTests",
      dependencies: ["SkeletonView"],
      path: "Tests/SkeletonViewTests"
    ),
  ]
)
