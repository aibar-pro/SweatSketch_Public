//
//  UserProfileView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2024.
//

import SwiftUI

struct UserProfileView: View {
    var onSubmit: (_: UserProfileModel) -> ()
    var onDismiss: () -> ()
    var onLogout: () -> ()
    
    @ObservedObject var viewModel: UserProfileViewModel

    var body: some View {
        VStack {
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.backward")
                    
                }
                .padding(.vertical, Constants.Design.spacing/2)
                .padding(.trailing, Constants.Design.spacing/2)
                
                Spacer()
                
                if !viewModel.isLoading {
                    Button(action: onLogout) {
                        HStack(spacing: Constants.Design.spacing/2) {
                            Text(Constants.Placeholders.UserProfile.logoutButtonLabel)
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                    .padding(.vertical, Constants.Design.spacing/2)
                    .padding(.leading, Constants.Design.spacing/2)
                }
            }
            .padding(.horizontal, Constants.Design.spacing)
            
            Spacer()
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView(Constants.Placeholders.loaderText)
                    Spacer()
                }
            } else {
                VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                    HStack {
                        Spacer()
                        Text("\(Constants.Placeholders.UserProfile.greetingLabel), \(viewModel.getGreeting())!")
                            .font(.title)
                        Spacer()
                    }
                    
                    VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                        Text(Constants.Placeholders.UserProfile.usernameLabel)
                            .font(.footnote)
                            .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                        TextField(Constants.Placeholders.UserProfile.usernameLabel, text:
                                    Binding(
                                        get: { viewModel.getUsername() },
                                        set: { viewModel.updateUsername(with: $0) }
                                    )
                        )
                        .padding(.leading, Constants.Design.spacing/2)
                        .padding(.bottom, Constants.Design.spacing)
                        
                        Text(Constants.Placeholders.UserProfile.ageLabel)
                            .font(.footnote)
                            .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                        Picker(Constants.Placeholders.UserProfile.ageLabel, selection:
                                Binding(
                                    get: { viewModel.getAge() },
                                    set: { viewModel.updateAge(with: $0) }
                                )
                        ) {
                            ForEach(0..<200, id: \.self) { unit in
                                Text("\(unit)").tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.leading, Constants.Design.spacing/2)
                        .padding(.bottom, Constants.Design.spacing)
                        
                        Text(Constants.Placeholders.UserProfile.heightLabel)
                            .font(.footnote)
                            .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                        Picker(Constants.Placeholders.UserProfile.heightLabel, selection:
                                Binding(
                                    get: { viewModel.getHeight() },
                                    set: { viewModel.updateHeight(with: $0) }
                                )
                        ) {
                            ForEach(0..<300, id: \.self) { unit in
                                Text("\(unit) \(Constants.Placeholders.UserProfile.heightUnitLabel)").tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.leading, Constants.Design.spacing/2)
                        .padding(.bottom, Constants.Design.spacing)
                        
                        Text("Weight")
                            .font(.footnote)
                            .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                        Picker("Weight", selection:
                                Binding(
                                    get: { viewModel.getWeight() },
                                    set: { viewModel.updateWeight(with: $0) }
                                )
                        ) {
                            ForEach(0..<400, id: \.self) { unit in
                                Text("\(unit) \(Constants.Placeholders.UserProfile.weightUnitLabel)").tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.leading, Constants.Design.spacing/2)
                        .padding(.bottom, Constants.Design.spacing)
                    
                        Spacer()
                    }
                    .padding(Constants.Design.spacing)
                    .materialCardBackgroundModifier()
                    
                    if let userProfile = viewModel.userProfile {
                        HStack {
                            Spacer()
                            Button(action: { onSubmit(userProfile) }) {
                                Text("Save")
                                    .primaryButtonLabelStyleModifier()
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, Constants.Design.spacing)
            }
        }
        .customAccentColorModifier(Constants.Design.Colors.textColorHighEmphasis)
    }
}

#Preview {
    UserProfileView(onSubmit: {_ in }, onDismiss: {}, onLogout: {}, viewModel: UserProfileViewModel())
}
