// swift-tools-version: 6.1
import PackageDescription

let deps: [Package.Dependency] = [
    .github("swiftlang/swift-toolchain-sqlite", exact: "1.0.4"),
    .github("sqlcipher/SQLCipher.swift.git", from: "4.11.0")
]

let targets: [Target] = [
    .target(
        name: "SQLite",
        dependencies: [
            .product(name: "SwiftToolchainCSQLite", package: "swift-toolchain-sqlite", condition: .when(platforms: [.linux, .windows, .android])),
            .product(name: "SQLCipher", package: "SQLCipher.swift")
        ],
        exclude: [
            "Info.plist"
        ],
        cSettings: [
            .define("SQLITE_HAS_CODEC", to: nil)
        ],
        swiftSettings: [
            .define("SQLITE_HAS_CODEC"),
            .define("SQLITE_SWIFT_SQLCIPHER")
        ]
    )
]

let testTargets: [Target] = [
    .testTarget(
        name: "SQLiteTests",
        dependencies: [
            "SQLite"
        ],
        path: "Tests/SQLiteTests",
        exclude: [
            "Info.plist"
        ],
        resources: [
            .copy("Resources")
        ],
        swiftSettings: [
            .define("SQLITE_SWIFT_SQLCIPHER")
        ]
    )
]

let package = Package(
    name: "SQLite.swift",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SQLite",
            targets: ["SQLite"]
        )
    ],
    traits: [
		.default(enabledTraits: [])
    ],
    dependencies: deps,
    targets: targets + testTargets,
    swiftLanguageModes: [.v5],
)

extension Package.Dependency {

    static func github(_ repo: String, exact ver: Version) -> Package.Dependency {
        .package(url: "https://github.com/\(repo)", exact: ver)
    }

    static func github(_ repo: String, from ver: Version) -> Package.Dependency {
        .package(url: "https://github.com/\(repo)", from: ver)
    }
}
