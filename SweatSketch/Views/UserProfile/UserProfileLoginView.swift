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
                            .font(.largeTitle)
                            .imageScale(.large)
                            .padding(.top, Constants.Design.spacing)
                        
                        Text("user.profile.login.title")
                            .fullWidthText(.title, alignment: .center)
                        
                        Text("user.profile.login.subtitle")
                            .fullWidthText(.subheadline, alignment: .center)
                        
                        LoginPasswordView(user: $user)
                        
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
            .customForegroundColorModifier(Constants.Design.Colors.textColorHighEmphasis)
        }
        .onDisappear(perform: onDismiss)
    }
    
    private var footer: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            Text("user.profile.signup.login.link.desctiption")
                .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
            
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
