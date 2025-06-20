//
//  TextFieldPopoverView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

struct TextFieldPopoverView: View {
    
    @State var newName: String = ""
    
    var popoverTitle: String = "Add Object"
    var textFieldLabel: String = "Enter object name..."
    var buttonLabel: String = "Add"
    
    var onDone: (_ : String) -> Void
    var onDiscard: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            HStack {
                Text(popoverTitle)
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    onDiscard()
                    newName.removeAll()
                }) {
                    Image(systemName: "xmark")
                }
            }
            
            TextField(textFieldLabel, text: $newName)
                .padding(.horizontal, Constants.Design.spacing/2)
                .padding(.vertical, Constants.Design.spacing)
                .background(
                    RoundedRectangle(cornerRadius: Constants.Design.cornerRadius)
                        .stroke(Constants.Design.Colors.backgroundStartColor)
                )
            
            HStack (spacing: Constants.Design.spacing) {
                Spacer()
                Button(action: {
                    newName.removeAll()
                    onDiscard()
                }) {
                    Text("app.button.cancel.label")
                        .secondaryButtonLabelStyleModifier()
                }
                Button(action: {
                    onDone(newName)
                    newName.removeAll()
                }) {
                    Text(buttonLabel)
                        .bold()
                        .primaryButtonLabelStyleModifier()
                }
                .disabled(newName.isEmpty)
            }
        }
        .padding(Constants.Design.spacing)
        .materialCardBackgroundModifier()
    }
}

#Preview {
    TextFieldPopoverView(popoverTitle: "Rename Entity", textFieldLabel: "Enter new name", buttonLabel: "Rename", onDone: {_ in }, onDiscard: {})
}
