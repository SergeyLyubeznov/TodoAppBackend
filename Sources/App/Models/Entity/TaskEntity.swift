//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 27.02.2023.
//

import Foundation
import Fluent
import Vapor

final class TaskEntity: Model, Content {

    static let schema = "task"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "description")
    var description: String
    
    @Field(key: "priority")
    var priority: String

    init() { }

    init(id: UUID? = nil, description: String) {
        self.id = id
        self.description = description
    }
}
