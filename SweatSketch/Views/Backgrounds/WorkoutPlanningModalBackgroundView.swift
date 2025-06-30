//
//  WorkoutPlanningModalBackgroundView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 30.03.2024.
//

import SwiftUI

struct WorkoutPlanningModalBackgroundView: View {
    let elementColor: Color = Constants.Design.Colors.screenBgAccent
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Constants.Design.Colors.screenBgStart,
                        Constants.Design.Colors.screenBgEnd
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    WorkoutPlanningModalBackgroundView()
}
