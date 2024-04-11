//
//  RenamePopoverView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.04.2024.
//

import SwiftUI

struct RenamePopoverView: View {
    
    @State var newName: String = ""
    
    var title: String = "New name"
    
    var onRename: (_ : String) -> Void
    var onDiscard: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    onDiscard()
                    newName.removeAll()
                }) {
                    Image(systemName: "xmark")
                }
            }
            
            TextField(title, text: $newName)
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
                    Text("Cancel")
                        .secondaryButtonLabelStyleModifier()
                }
                Button(action: {
                    onRename(newName)
                    newName.removeAll()
                }) {
                    Text("Rename")
                        .bold()
                        .primaryButtonLabelStyleModifier()
                }
                .disabled(newName.isEmpty)
            }
        }
        .padding(Constants.Design.spacing)
        .materialCardBackgroundModifier()
        .padding(.horizontal, Constants.Design.spacing)
    }
}

#Preview {
    RenamePopoverView(title: "New entity name", onRename: {_ in }, onDiscard: {})
}
