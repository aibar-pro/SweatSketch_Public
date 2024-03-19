//
//  BackgroundGradientView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 29.02.2024.
//

import Foundation
import SwiftUI

struct BackgroundGradientView : View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Constants.Design.Colors.backgroundStartColor, Constants.Design.Colors.backgroundEndColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(.all)
    }
}
