import PackageDescription


let package = Package(
    name: "FwiCore",
    targets: [
        Target(
            name: "FwiCore"
        ),
        Target(
            name: "FwiCoreTests",
            dependencies: [
                .Target(name: "FwiCore")
            ]
        )
    ],
    exclude: [
        "Tests/Resources"
    ]
)
