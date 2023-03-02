import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Setup Postgres
    guard let host = Environment.get(Constants.Database.Host),
    let name = Environment.get(Constants.Database.Name),
    let user = Environment.get(Constants.Database.User),
          let password = Environment.get(Constants.Database.Password) else {
        fatalError("Can't setup Database. Check env file.")
    }
    
    app.databases.use(.postgres(hostname: host, username: user,
                                password: password, database: name), as: .psql)
    
    app.logger.logLevel = .debug
    
    // register routes
    try routes(app)
}
