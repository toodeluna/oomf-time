// swift-tools-version: 5.10

import PackageDescription

let package = Package(
  name: "oomf-time",
  platforms: [.macOS(.v12)],
  products: [.executable(name: "oomf-time", targets: ["oomf-time"])],
  targets: [.executableTarget(name: "oomf-time", path: "oomf-time")]
)
