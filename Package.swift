import PackageDescription


let package = Package(
    name: "FwiCore",
    products: [
        .library(name: "FwiCore", targets: ["FwiCore"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "FwiCore",
            dependencies: []),
        .testTarget(
            name: "FwiCoreTests",
            dependencies: ["FwiCore"]),
    ]
)
