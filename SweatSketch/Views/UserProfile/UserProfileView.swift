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
    //TODO: Add localization and get values from ViewModel
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
                        Text("Hello, \(viewModel.userProfile?.username ?? viewModel.userProfile?.login ?? "noname")!")
                            .font(.title)
                        Spacer()
                    }
                    
                    VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                        Text("Username")
                            .font(.footnote)
                            .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                        TextField("Username", text:
                                    Binding(
                                        get: { viewModel.userProfile?.username ?? "noname" },
                                        set: { viewModel.updateUsername(with: $0) }
                                    )
                        )
                        .padding(.leading, Constants.Design.spacing/2)
                        .padding(.bottom, Constants.Design.spacing)
                        
                        Text("Age")
                            .font(.footnote)
                            .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                        Picker("Age", selection:
                                Binding(
                                    get: { Int(viewModel.userProfile?.age ?? 18) },
                                    set: { viewModel.updateAge(with: $0) }
                                )
                        ) {
                            ForEach(0..<200, id: \.self) { year in
                                Text("\(year)").tag(year)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.leading, Constants.Design.spacing/2)
                        .padding(.bottom, Constants.Design.spacing)
                        
                        Text("Height")
                            .font(.footnote)
                            .customForegroundColorModifier(Constants.Design.Colors.textColorMediumEmphasis)
                        Picker("Height", selection:
                                Binding(
                                    get: { Int(viewModel.userProfile?.height ?? 100) },
                                    set: { viewModel.updateHeight(with: $0) }
                                )
                        ) {
                            ForEach(0..<300, id: \.self) { year in
                                Text("\(year) cm").tag(year)
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
                                    get: { Int(viewModel.userProfile?.weight ?? 50) },
                                    set: { viewModel.updateWeight(with: $0) }
                                )
                        ) {
                            ForEach(0..<300, id: \.self) { year in
                                Text("\(year) kg").tag(year)
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
