//
//  WorkoutPlanningMainBackgroundView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 29.02.2024.
//

import SwiftUI

struct WorkoutPlanningMainBackgroundView : View {
    let elementColor: Color = Constants.Design.Colors.backgroundAccentColor
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Constants.Design.Colors.backgroundStartColor, Constants.Design.Colors.backgroundEndColor]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                .size(CGSize(width: 500, height: 250))
                .rotation(.degrees(-5))
                .offset(x: 0, y: -25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [elementColor, .clear]),
                        startPoint: .top,
                        endPoint: .bottomTrailing
                    )
                )
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 100))
                .imageScale(.large)
                .rotationEffect(Angle(degrees: 30))
                .offset(x: 100, y: -50)
                .customForegroundColorModifier(elementColor)
            
            Image(systemName: "gym.bag.fill")
                .font(.system(size: 100))
                .imageScale(.large)
                .rotationEffect(Angle(degrees: -15))
                .offset(x: -75, y: 150)
                .customForegroundColorModifier(elementColor)
            
            Ellipse()
                .size(CGSize(width: 450, height: 350))
                .offset(x: 200, y: 675)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [elementColor, .clear]),
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading
                    )
                )
        }
        .ignoresSafeArea(.all)
    }
}

struct WorkoutPlanningMainBackgroundView_Preview : PreviewProvider {
    
    static var previews: some View {
        WorkoutPlanningMainBackgroundView()
    }
}
