//
//  UserProfileLoginView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import SwiftUI

struct UserProfileLoginView: View {
    @State var user = UserCredentialModel()
    
    var onLogin: (_ user: UserCredentialModel) -> Void = { user in }
    var onDismiss: () -> Void = {}
    
    var body: some View {
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            VStack(alignment: .center, spacing: Constants.Design.spacing) {
                Image(systemName: "person.badge.key")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .padding(.top, Constants.Design.spacing)
                
                Text("Welcome Back")
                    .font(.title)
                
                Text("Login to your account")
                    .font(.subheadline)
                
                LoginPasswordView(user: $user)
                
                Button(action: {
                    onLogin(user)
                }) {
                    Text("Login")
                        .accentButtonLabelStyleModifier()
                }
                
                Divider()
                    .padding(.top, Constants.Design.spacing)
                
                
                HStack(alignment: .center) {
                    Text("Don't have an account?")
                        .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                    
                    Button(action: {
                        print("SIGNUP_CLICK")
                    }) {
                        Text("Sign up")
                            .fontWeight(.bold)
                            .customForegroundColorModifier(Constants.Design.Colors.linkColor)
                    }
                }
                
            }
            .customForegroundColorModifier(Constants.Design.Colors.textColorHighEmphasis)
        }
        .onDisappear(perform: onDismiss)
    }
}

#Preview {
    UserProfileLoginView(user: UserCredentialModel())
}
