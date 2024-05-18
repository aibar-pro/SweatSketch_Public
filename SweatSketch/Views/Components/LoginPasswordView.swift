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
        if #available(iOS 16.0, *) {
            Form {
                TextField("Email", text: $user.login)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $user.password)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            .scrollContentBackground(.hidden)
        } else {
            VStack {
                VStack (spacing: Constants.Design.spacing/2) {
                    TextField("Email", text: $user.login)
                        .disableAutocorrection(true)
                    Divider()
                    SecureField("Password", text: $user.password)
                }
                .padding(Constants.Design.spacing)
                .materialCardBackgroundModifier()
                Spacer()
            }
            .padding(.top, Constants.Design.spacing)
            .padding(.horizontal, Constants.Design.spacing)
        }
    }
}

#Preview {
    LoginPasswordView(user: .constant(UserCredentialModel(login: "@ss", password: "123")))
}
