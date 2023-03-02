//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 01.03.2023.
//

import Fluent
import Vapor

final class UserTokenEntity: Model, Content {
    static let schema = "user_token"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: UserEntity

    init() { }

    init(id: UUID? = nil, value: String, userID: UserEntity.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension UserTokenEntity: ModelTokenAuthenticatable {
    static let valueKey = \UserTokenEntity.$value
    static let userKey = \UserTokenEntity.$user

    var isValid: Bool {
        true
    }
}
