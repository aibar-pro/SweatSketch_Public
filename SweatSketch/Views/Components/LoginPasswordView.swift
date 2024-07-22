//
//  LoginPasswordView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import SwiftUI

struct LoginPasswordView: View {
    @Binding var user: UserCredentialModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: Constants.Design.spacing) {
            Text(Constants.Placeholders.emailLabel)
                .font(.footnote)
                .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
            TextField(Constants.Placeholders.emailLabel, text:
                        $user.login
            )
            .disableAutocorrection(true)
            .padding(.leading, Constants.Design.spacing/2)
            .padding(.bottom, Constants.Design.spacing)
            
            Text(Constants.Placeholders.passwordLabel)
                .font(.footnote)
                .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
            SecureField(Constants.Placeholders.passwordLabel, text:
                        $user.password
            )
            .disableAutocorrection(true)
            .padding(.leading, Constants.Design.spacing/2)
        }
        .padding(Constants.Design.spacing)
        .materialCardBackgroundModifier()
    }
}

#Preview {
    LoginPasswordView(user: .constant(UserCredentialModel(login: "@ss", password: "123456")))
}
