//
//  RespondMessageModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.06.2024.
//

import Foundation
import SweatSketchSharedModule

struct ResponseMessageModel : Codable {
    var message: String
}

extension SweatSketchSharedModule.ResponseMessageModel {
    func toLocal() -> ResponseMessageModel {
        return ResponseMessageModel(
            message: self.message
        )
    }
}
