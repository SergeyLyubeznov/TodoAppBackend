//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 03.03.2023.
//

import Vapor
import Fluent

struct UserTokenMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("user_token")
            .field("id", .uuid, .identifier(auto: false))
            .field("user_id", .uuid, .required, .references("user", "id", onDelete: .cascade))
            .field("value", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user_token").delete()
    }
}
