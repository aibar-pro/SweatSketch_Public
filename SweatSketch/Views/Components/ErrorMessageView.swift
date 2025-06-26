//
//  ErrorMessageView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 04.04.2024.
//

import SwiftUI

struct ErrorMessageView: View {
    let text: String
    let color: Color = Color.red.opacity(0.87)
    
    let textMaxLength = 150
    
    var body: some View {
        HStack (alignment: .center, spacing: Constants.Design.spacing/2) {
            Image(systemName: "exclamationmark.octagon")
            Text(text.prefix(textMaxLength))
            Spacer()
        }
        .adaptiveForegroundStyle(Color.white.opacity(0.87))
        .padding(.all, Constants.Design.spacing)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .stroke(color, lineWidth: 3)
                RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                    .fill(color)
            }
            )
    }
}

#Preview {
    ErrorMessageView(text: Constants.Placeholders.activeWorkoutItemError)
}
