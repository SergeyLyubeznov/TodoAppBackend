import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    let protected = app.grouped(UserAuthenticator())
        .grouped(UserEntity.guardMiddleware())
    
    app.get { req async in
        "It works!"
    }
    
    protected.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    protected.get("tasks") { req async throws in
        try await TaskEntity.query(on: req.db).all()
    }
    
    protected.post("tasks") { req async throws -> TaskEntity in
        let task = try req.content.decode(TaskEntity.self)
        try await task.create(on: req.db)
        return task
    }
    
    protected.delete("tasks", ":id") { req async throws -> TaskEntity in
        guard let task = try await TaskEntity.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await task.delete(on: req.db)
        return task
    }
    
    protected.patch("tasks", ":id") { req async throws -> TaskEntity in
        // Decode the request data.
        let patch = try req.content.decode(TaskEntity.self)
        // Fetch the desired user from the database.
        guard let task = try await TaskEntity.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        task.priority = patch.priority
        task.description = patch.description
        try await task.save(on: req.db)
        return task
    }
    
    app.post("registration") { req async throws -> Login in
        try UserEntity.Create.validate(content: req)
        let create = try req.content.decode(UserEntity.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try UserEntity(
            email: create.email,
            password: Bcrypt.hash(create.password)
        )
        try await user.save(on: req.db)
        let token = try user.generateToken()
        try await token.save(on: req.db)
        
        let login = Login(token: token.value,
                          user: User(id: user.id, email: user.email))
        return login
    }
    
    let passwordProtected = app.grouped(UserEntity.authenticator())
    passwordProtected.post("login") { req async throws -> Login in
        let user = try req.auth.require(UserEntity.self)
        
        let token = try user.generateToken()
        
        if let existedToken = try await UserTokenEntity.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .first() {
            
            existedToken.value = token.value
            try await existedToken.update(on: req.db)
        } else {
            try await token.save(on: req.db)
        }
        
        let login = Login(token: token.value,
                          user: User(id: user.id, email: user.email))
        return login
    }
}
