//
//  IconButton.swift
//  SweatSketch
//
//  Created by aibaranchikov on 16.06.2025.
//

import SwiftUI

//Menu {
//    Button(action: {
//        coordinator.goToAddWorkout()
//    }) {
//        Text("collection.add.workout.button.label")
//    }
//    Button(action: {
//        coordinator.goToWorkoutLst()
//    }) {
//        Text("collection.edit.list.button.label")
//    }
//} label: {
//    Image(systemName: "ellipsis.circle")
//        .font(.body)
//        .customForegroundColorModifier(Constants.Design.Colors.textColorHighEmphasis)
//}
//.disabled(isCarouselHidden)



struct IconButton: View {
    let systemImage: String
    let action: () -> Void
    let config: CustomButtonConfig
    
    @Binding var isDisabled: Bool
    
    init(systemImage: String,
         style: CustomButtonStyle,
         isDisabled: Binding<Bool> = .constant(false),
         action: @escaping () -> Void) {
        self.action = action
        self.systemImage = systemImage
        self.config = style.config
        self._isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(config.isBold ? config.font.bold() : config.font)
                .customForegroundColorModifier(config.foregroundColor)
                .padding(.horizontal, Constants.Design.buttonLabelPaddding)
                .padding(.vertical, Constants.Design.buttonLabelPaddding)
                .background(config.backgroundColor)
                .opacity(isDisabled ? 0.35 : 1)
                .contentShape(Circle())
                .clipShape(Circle())
                .shadow(radius: config.hasShadow ? config.shadowRadius : 0)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    IconButton(
        systemImage: "checkmark",
        style: .accent,
        isDisabled: .constant(true),
        action: {}
    )
}
