// swift-tools-version:4.0
import PackageDescription


let package = Package(
    name: "FwiCore",
    products: [
        .library(name: "FwiCore", targets: ["FwiCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0"),
    ],
    targets: [
        .target(name: "FwiCore", dependencies: ["Alamofire"], path: "Sources"),
        .testTarget(name: "FwiCoreTests", dependencies: ["Alamofire", "FwiCore"]),
    ],
    swiftLanguageVersions: [4]
)
