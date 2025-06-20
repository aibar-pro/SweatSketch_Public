//
//  FormField.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2025.
//

import SwiftUI

struct FormField<InputField: View>: View {
    var title: LocalizedStringKey
    let inputField: () -> InputField
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing / 2) {
            Text(title)
                .fullWidthText(.caption)
                .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
            inputField()
        }
    }
}

#Preview {
    FormField(title: "user.profile.email") {
        TextField("", text: .constant("Preview"))
    }
}
