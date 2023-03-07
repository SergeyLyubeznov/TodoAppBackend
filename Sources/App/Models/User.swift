//
//  File 2.swift
//  
//
//  Created by Serhii Liubeznov on 01.03.2023.
//

import Foundation
import Vapor

struct User: Content {
    var id: UUID?
    let email: String
    var firstName = "123"
    var lastName = "123"
}
