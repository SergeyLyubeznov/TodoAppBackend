//
//  File.swift
//  
//
//  Created by Serhii Liubeznov on 01.03.2023.
//

import Foundation
import Vapor

struct Login: Content {
    let token: String
    let user: User
}
