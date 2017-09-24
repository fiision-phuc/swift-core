// swift-tools-version:4.0
import PackageDescription


let package = Package(
    name: "FwiCore",
    products: [
        .library(name: "FwiCore", targets: ["FwiCore"]),
        .library(name: "FwiCoreRX", targets: ["FwiCoreRX"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "FwiCore", dependencies: ["Alamofire"], path: "Sources/FwiCore"),
        .target(name: "FwiCoreRX", dependencies: ["Alamofire", "RxSwift", "FwiCore"], path: "Sources/FwiCoreRX"),
//        .testTarget(name: "FwiCoreTests", dependencies: ["Alamofire", "FwiCore"]),
//        .testTarget(name: "FwiCoreRXTests", dependencies: ["Alamofire", "RxBlocking", "RxCocoa", "RxSwift", "FwiCore", "FwiCoreRX"]),
    ],
    swiftLanguageVersions: [4]
)
