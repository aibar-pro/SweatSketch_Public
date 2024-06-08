//
//  UserProfileSignupView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 08.06.2024.
//

import SwiftUI

struct UserProfileSignupView: View {
    @State var user = UserCredentialModel()
    
    var onSignup: (_ user: UserCredentialModel) -> Void = { user in }
    var onDismiss: () -> Void = {}
    var onLogin: () -> Void = {}
    
    var body: some View {
        ZStack {
            WorkoutPlanningModalBackgroundView()
            
            VStack(alignment: .center, spacing: Constants.Design.spacing) {
                Image(systemName: "person.badge.plus")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .padding(.top, Constants.Design.spacing)
                
                Text(Constants.Placeholders.UserProfile.signupScreenTitle)
                    .font(.title)
                
                Text(Constants.Placeholders.UserProfile.signupScreenText)
                    .font(.subheadline)
                
                LoginPasswordView(user: $user)
                
                Button(action: {
                    onSignup(user)
                }) {
                    Text(Constants.Placeholders.UserProfile.signupButtonLabel)
                        .accentButtonLabelStyleModifier()
                }
                
                Divider()
                    .padding(.top, Constants.Design.spacing)
                
                
                HStack(alignment: .center) {
                    Text(Constants.Placeholders.UserProfile.signupLinkText)
                        .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                    
                    Button(action: onLogin) {
                        Text(Constants.Placeholders.UserProfile.loginButtonLabel)
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
    UserProfileSignupView()
}
