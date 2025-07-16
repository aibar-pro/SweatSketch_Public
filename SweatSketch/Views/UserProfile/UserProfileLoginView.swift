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
    var onSignup: () -> Void = {}
    
    var body: some View {
        ZStack {
            VStack{
                ScrollView {
                    VStack(alignment: .center, spacing: Constants.Design.spacing) {
                        ToolbarIconButton
                            .backButton(action: onDismiss)
                            .buttonView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "person.badge.key")
                            .font(.title.weight(.semibold))
                            .padding(.top, Constants.Design.spacing)
                        
                        Text("user.profile.login.title")
                            .fullWidthText(.title, weight: .semibold, alignment: .center)
                        
                        Text("user.profile.login.subtitle")
                            .fullWidthText(.subheadline, alignment: .center)
                        
                        VStack(alignment: .center, spacing: Constants.Design.spacing) {
           
                            
                            LoginPasswordView(user: $user)
                        }
                        .padding(Constants.Design.spacing)
                        .materialBackground()
                        .lightShadow()
                        
                        RectangleButton(
                            "user.profile.login.button.label",
                            style: .primary,
                            isFullWidth: true,
                            action: {
                                onLogin(user)
                            }
                        )
                    }
                    .padding(Constants.Design.spacing)
                }
                Divider()
                
                footer
            }
            .adaptiveForegroundStyle(Constants.Design.Colors.elementFgHighEmphasis)
        }
        .onDisappear(perform: onDismiss)
    }
    
    private var footer: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            Text("user.profile.signup.login.link.desctiption")
                .adaptiveForegroundStyle(Constants.Design.Colors.elementFgMediumEmphasis)
            
            RectangleButton(
                "user.profile.signup.button.label",
                style: .inlineLink,
                action: onSignup
            )
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    UserProfileLoginView(user: UserCredentialModel())
}
