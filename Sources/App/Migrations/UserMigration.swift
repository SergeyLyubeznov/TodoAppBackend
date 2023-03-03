//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 02.03.2023.
//

import Vapor
import Fluent

struct UserMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("user")
            .field("id", .uuid, .identifier(auto: false))
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
    }
}
