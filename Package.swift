import PackageDescription


let package = Package(
    name: "FwiCore",
    targets: [
        Target(
            name: "FwiCore"
        )
    ],
    exclude: [
        "Tests/Resources"
    ]
)
