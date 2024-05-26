//
//  UserProfileModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.06.2024.
//

import Foundation
import SweatSketchSharedModule

struct UserProfileModel: Codable {
    var login: String
    var username: String?
    var age: Int32?
    var height: Double?
    var weight: Double?
}

extension UserProfileModel {
    func toShared() -> SweatSketchSharedModule.UserProfileModel {
        return SweatSketchSharedModule.UserProfileModel(
            login: self.login,
            username: self.username,
            age: self.age?.kotlinInt,
            height: self.height?.kotlinDouble,
            weight: self.weight?.kotlinDouble
        )
    }
}

extension SweatSketchSharedModule.UserProfileModel {
    func toLocal() -> UserProfileModel {
        return UserProfileModel(
            login: self.login,
            username: self.username,
            age: self.age?.int32Value,
            height: self.height?.doubleValue,
            weight: self.weight?.doubleValue
        )
    }
}
