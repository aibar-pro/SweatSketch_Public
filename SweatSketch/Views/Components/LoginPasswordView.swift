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
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            FormField(title: "app.login.form.email.label") {
                TextField("", text:$user.login)
                    .adaptiveForegroundStyle(Constants.Design.Colors.elementFgHighEmphasis)
                    .adaptiveTint(Constants.Design.Colors.elementBgPrimary)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
            }
            
            FormField(title: "app.login.form.password.label") {
                SecureField("", text: $user.password)
                    .adaptiveForegroundStyle(Constants.Design.Colors.elementFgHighEmphasis)
                    .adaptiveTint(Constants.Design.Colors.elementBgPrimary)
                    .disableAutocorrection(true)
            }
        }
    }
}

#Preview {
    LoginPasswordView(user: .constant(UserCredentialModel(login: "@ss", password: "123456")))
}
