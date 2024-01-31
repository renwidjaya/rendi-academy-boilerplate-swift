import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "academy_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "@Admin2023",
        database: Environment.get("DATABASE_NAME") ?? "academy",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(UserModelMigration())
    app.migrations.add(TokenModelMigration())

    //User seeds
    app.migrations.add(CrateUserSeed())

    try await app.autoMigrate()
    // register routes
    try routes(app)
}
