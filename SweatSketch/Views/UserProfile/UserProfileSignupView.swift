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
            
            VStack{
                ScrollView {
                    VStack(alignment: .center, spacing: Constants.Design.spacing/2) {
                        Image(systemName: "person.badge.plus")
                            .font(.largeTitle)
                            .imageScale(.large)
                            .padding(.top, Constants.Design.spacing)
                        
                        Text(Constants.Placeholders.UserProfile.signupScreenTitle)
                            .font(.title)
                        
                        Text(Constants.Placeholders.UserProfile.signupScreenText)
                            .font(.subheadline)
                        
                        LoginPasswordView(user: $user)
                            .padding(Constants.Design.spacing)
                        
                        Button(action: {
                            onSignup(user)
                        }) {
                            Text(Constants.Placeholders.UserProfile.signupButtonLabel)
                                .accentButtonLabelStyleModifier()
                        }
                    }
                    .customForegroundColorModifier(Constants.Design.Colors.textColorHighEmphasis)
                }
                Divider()
                    .padding(.vertical, Constants.Design.spacing/2)
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
        }
        .onDisappear(perform: onDismiss)
    }
}

#Preview {
    UserProfileSignupView()
}
