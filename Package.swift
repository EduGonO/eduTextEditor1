// swift-tools-version:5.9
import PackageDescription
let package = Package(
  name: "BlockNoteKit",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [.library(name: "BlockNoteKit", targets: ["BlockNoteKit"])],
  targets: [.target(
    name: "BlockNoteKit",
    resources: [.copy("Web")])])