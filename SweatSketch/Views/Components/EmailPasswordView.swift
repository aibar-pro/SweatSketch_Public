//
//  EmailPasswordView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import SwiftUI

struct EmailPasswordView: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Form {
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            .scrollContentBackground(.hidden)
        } else {
            VStack {
                VStack (spacing: Constants.Design.spacing/2) {
                    TextField("Email", text: $email)
                        .disableAutocorrection(true)
                    Divider()
                    SecureField("Password", text: $password)
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
    EmailPasswordView(email: .constant("e@mail.com"), password: .constant("qwerty"))
}
