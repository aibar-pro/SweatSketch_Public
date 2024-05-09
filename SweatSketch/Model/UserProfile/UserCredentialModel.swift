//
//  UserCredentialModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import Foundation

class UserCredentialModel: Encodable {
    let username: String
    let password: String
    
    init(email: String, password: String) {
        self.username = email
        self.password = password
    }
}
