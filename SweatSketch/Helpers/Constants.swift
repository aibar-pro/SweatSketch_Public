//
//  Constants.swift
//  SweatSketch
//
//  Created by aibaranchikov on 28.02.2024.
//

import Foundation
import SwiftUI

struct Constants {
    struct Design {

        static let cornerRadius = CGFloat(16)
        static let spacing = CGFloat(20)
        
        struct Colors {
            static let backgroundStartColor = Color("background_gradient_start").opacity(0.5)
            static let backgroundEndColor = Color("background_gradient_end").opacity(0.5)
            
            static let buttonBackgroundColor = Color("button_background")
        }
    }
}
