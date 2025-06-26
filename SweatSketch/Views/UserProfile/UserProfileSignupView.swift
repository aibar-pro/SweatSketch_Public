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
                ScrollView {
                    VStack(alignment: .center, spacing: Constants.Design.spacing) {
                        Image(systemName: "person.badge.plus")
                            .font(.largeTitle)
                            .imageScale(.large)
                        
                        Text("user.profile.signup.title")
                            .fullWidthText(.title, alignment: .center)
                        
                        Text("user.profile.signup.subtitle")
                            .fullWidthText(.subheadline, alignment: .center)
                        
                        LoginPasswordView(user: $user)
                    
                        RectangleButton(
                            "user.profile.signup.button.label",
                            style: .primary,
                            isFullWidth: true,
                            action: {
                                onSignup(user)
                            }
                        )
                    }
                    .padding(Constants.Design.spacing)
                    .adaptiveForegroundStyle(Constants.Design.Colors.elementFgHighEmphasis)
                }
                
                Divider()
                
                footer
            }
        }
        .onDisappear(perform: onDismiss)
    }
    
    private var footer: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            Text("user.profile.login.signup.link.desctiption")
                .adaptiveForegroundStyle(Constants.Design.Colors.elementFgMediumEmphasis)
            
            RectangleButton(
                "user.profile.login.button.label",
                style: .inlineLink,
                action: onLogin
            )
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    UserProfileSignupView()
}
