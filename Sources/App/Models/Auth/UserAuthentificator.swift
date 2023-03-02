//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 01.03.2023.
//

import Foundation
import Vapor
import Fluent

struct UserAuthenticator: AsyncBearerAuthenticator {
    typealias User = App.User

    func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) async throws {
        
        if let token = try await UserTokenEntity.query(on: request.db)
            .filter(\.$value == bearer.token)
            .with(\.$user)
            .first() {
            
            request.auth.login(token.user)
            
//            if let user = try await UserEntity.query(on: request.db)
//                .filter(\.$id == token.user.requireID())
//                .first() {
//                request.auth.login(user)
//            }
        }
   }
}
