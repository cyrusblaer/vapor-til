import FluentPostgreSQL
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)

    /**
    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Acronym.self, database: .sqlite)
    migrations.add(model: Category.self, database: .sqlite)
    migrations.add(model: AcronymCategoryPivot.self, database: .sqlite)
    migrations.add(model: Token.self, database: .sqlite)
    migrations.add(migration: AdminUser.self, database: .sqlite)
    
    services.register(migrations)
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
    */
    
    var databases = DatabasesConfig()
    
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
//    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let databaseName: String
    let databasePort: Int
    
    if (env == .testing) {
        databaseName = "vapor-test"
        databasePort = 5433
    } else {
        databaseName = Environment.get("DATABASE_DB") ?? "vapor"
        databasePort = 5432
    }
    
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, port: databasePort, username: username, database: databaseName, password: password)
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    var migrations = MigrationConfig()
    
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Acronym.self, database: .psql)
    migrations.add(model: Category.self, database: .psql)
    migrations.add(model: AcronymCategoryPivot.self, database: .psql)
    
    services.register(migrations)
    
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
}
