//
//  UserProfileModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.06.2024.
//

import Foundation
import SweatSketchSharedModule

struct UserProfileModel: Codable {
    var login: String?
    var username: String?
    var age: Int?
    var height: Double?
    var weight: Double?
}

extension UserProfileModel {
    func toShared() -> SweatSketchSharedModule.UserProfileDto {
        return SweatSketchSharedModule.UserProfileDto(
            username: self.username,
            age: self.age?.kotlinInt,
            height: self.height?.kotlinDouble,
            weight: self.weight?.kotlinDouble
        )
    }
}

extension SweatSketchSharedModule.UserProfileDto {
    func toLocal() -> UserProfileModel {
        return UserProfileModel(
            username: self.username,
            age: self.age?.intValue,
            height: self.height?.doubleValue,
            weight: self.weight?.doubleValue
        )
    }
}
