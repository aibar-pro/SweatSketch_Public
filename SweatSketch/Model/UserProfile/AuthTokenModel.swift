//
//  UserTokenModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import Foundation

struct AuthTokenModel: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: UInt64
}
