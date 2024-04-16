//
//  ActiveWorkoutSummaryBackgroundView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.04.2024.
//

import SwiftUI

struct ActiveWorkoutSummaryBackgroundView: View {
    let elementColor: Color = Constants.Design.Colors.backgroundAccentColor
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Constants.Design.Colors.backgroundStartColor, Constants.Design.Colors.backgroundEndColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            Image(systemName: "fireworks")
                .font(.system(size: 400))
                .rotationEffect(Angle(degrees: isAnimating ? 5 : -5))
                .foregroundColor(elementColor)
                .scaleEffect(isAnimating ? 1.25 : 1.0)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ActiveWorkoutSummaryBackgroundView()
}
