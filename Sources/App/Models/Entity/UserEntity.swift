//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 28.02.2023.
//

import Foundation
import Fluent
import Vapor

final class UserEntity: Model, Content {
    static let schema = "user"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    init() { }

    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

extension UserEntity {
    struct Create: Content {
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension UserEntity.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension UserEntity {
    func generateToken() throws -> UserTokenEntity {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

extension UserEntity: ModelAuthenticatable {
    static let usernameKey = \UserEntity.$email
    static let passwordHashKey = \UserEntity.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
