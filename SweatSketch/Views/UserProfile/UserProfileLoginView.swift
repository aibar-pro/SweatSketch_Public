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
                
                Text(Constants.Placeholders.UserProfile.loginScreenTitle)
                    .font(.title)
                
                Text(Constants.Placeholders.UserProfile.loginScreenText)
                    .font(.subheadline)
                
                LoginPasswordView(user: $user)
                
                Button(action: {
                    onLogin(user)
                }) {
                    Text(Constants.Placeholders.UserProfile.loginButtonLabel)
                        .accentButtonLabelStyleModifier()
                }
                
                Divider()
                    .padding(.top, Constants.Design.spacing)
                
                
                HStack(alignment: .center) {
                    Text(Constants.Placeholders.UserProfile.signupLinkText)
                        .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                    
                    Button(action: {
                        print("SIGNUP_CLICK")
                    }) {
                        Text(Constants.Placeholders.UserProfile.signupButtonLabel)
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
