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
            LinearGradient(gradient: Gradient(colors: [Constants.Design.Colors.backgroundStartColor, Constants.Design.Colors.backgroundEndColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            RoundedRectangle(cornerRadius: Constants.Design.cornerRadius, style: .continuous)
                .size(CGSize(width: 400, height: 400))
                .rotation(.degrees(60))
                .offset(x: -300, y: -300)
                .fill(elementColor)
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 100))
                .imageScale(.large)
                .rotationEffect(Angle(degrees: 30))
                .offset(x: 100, y: -50)
                .foregroundColor(elementColor)
            
            Image(systemName: "gym.bag.fill")
                .font(.system(size: 100))
                .imageScale(.large)
                .rotationEffect(Angle(degrees: -15))
                .offset(x: -75, y: 150)
                .foregroundColor(elementColor)
            
            Ellipse()
                .size(CGSize(width: 450, height: 350))
                .offset(x: 200, y: 675)
                .fill(elementColor)
        }
        .ignoresSafeArea(.all)
    }
}

struct WorkoutPlanningMainBackgroundView_Preview : PreviewProvider {
    
    static var previews: some View {
        WorkoutPlanningMainBackgroundView()
    }
}
