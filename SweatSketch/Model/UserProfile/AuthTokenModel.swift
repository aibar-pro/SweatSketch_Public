//
//  UserTokenModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import Foundation
import SweatSketchSharedModule

struct AuthTokenModel: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: UInt64
}

extension SweatSketchSharedModule.AuthTokenDto {
    func toLocal() -> AuthTokenModel {
        return AuthTokenModel(
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            expiresIn: self.expiresIn
        )
    }
}
