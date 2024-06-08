//
//  UserCredentialModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import Foundation
import SweatSketchSharedModule

struct UserCredentialModel: Codable {
    var login: String = ""
    var password: String = ""
}

extension UserCredentialModel {
    func toShared() -> SweatSketchSharedModule.UserCredentialModel {
        return SweatSketchSharedModule.UserCredentialModel(
            login: self.login,
            password: self.password
        )
    }
}
