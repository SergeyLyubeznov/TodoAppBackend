//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 03.03.2023.
//

import Vapor
import Fluent

struct TaskMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("task")
            .field("id", .uuid, .identifier(auto: false))
            .field("description", .string, .required)
            .field("title", .string, .required)
            .field("priority", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("task").delete()
    }
}
