// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DiffReport",
  products: [
    .executable(name: "cli", targets: ["DiffReport"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "DiffReport",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser")
    ]),
    .testTarget(
      name: "DiffReportTests",
      dependencies: ["DiffReport"]),
  ]
)
