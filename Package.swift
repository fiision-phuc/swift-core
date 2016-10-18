import PackageDescription


let package = Package(
    name: "FwiCore",
    targets: [
        Target(
            name: "FwiCore"
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/ReactiveX/RxSwift.git", Version(3, 0, 0, prereleaseIdentifiers: ["rc", "1"])),
    ],
    exclude: [
        "Tests/Resources"
    ]
)
