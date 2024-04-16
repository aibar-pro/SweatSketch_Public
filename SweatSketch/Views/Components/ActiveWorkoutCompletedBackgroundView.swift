//
//  ActiveWorkoutCompletedBackgroundView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.04.2024.
//

import SwiftUI

struct ActiveWorkoutCompletedBackgroundView: View {
    let elementColor: Color = Constants.Design.Colors.backgroundAccentColor
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Constants.Design.Colors.backgroundStartColor, Constants.Design.Colors.backgroundEndColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            Image(systemName: "medal.fill")
                .font(.system(size: 150))
                .offset(y: 200)
                .foregroundColor(elementColor)
                .scaleEffect(isAnimating ? 1.25 : 1.0)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ActiveWorkoutCompletedBackgroundView()
}
