//
//  UserProfileView.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.06.2024.
//

import SwiftUI

struct UserProfileView: View {
    var onSubmit: (UserProfileModel) -> ()
    var onDismiss: () -> ()
    var onLogout: () -> ()
    
    @ObservedObject var viewModel: UserProfileViewModel
  
    var body: some View {
        VStack(alignment: .center, spacing: Constants.Design.spacing) {
            toolbarView
            
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    ProgressView("app.loading")
                        .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    content
                }
            }
        }
        .padding(Constants.Design.spacing)
    }
    
    private var toolbarView: some View {
        HStack(alignment: .center, spacing: Constants.Design.spacing) {
            ToolbarIconButton
                .backButton(action: onDismiss)
                .buttonView(style: .inline)
            
            Spacer(minLength: 0)
            
            if !viewModel.isLoading {
                CapsuleButton(
                    content: {
                        HStack(alignment: .center, spacing: Constants.Design.spacing / 2) {
                            Text("user.profile.logout.button.label")
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    },
                    style: .inline,
                    action: {
                        onLogout()
                    }
                )
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            Text("\(Constants.Placeholders.UserProfile.greetingLabel), \(viewModel.getGreeting())!")
                .fullWidthText(.title, alignment: .center)
            
            VStack (alignment: .leading, spacing: Constants.Design.spacing) {
                usernameFieldView
                
                ageFieldView
                
                heightFieldView
                
                weightFieldView
            }
            .padding(Constants.Design.spacing)
            .materialCardBackgroundModifier()
            
            if let userProfile = viewModel.userProfile {
                RectangleButton(
                    "app.button.save.label",
                    style: .primary,
                    isFullWidth: true,
                    action: {
                        onSubmit(userProfile)
                    }
                )
            }
        }
    }
    
    private var usernameFieldView: some View {
        FormField(title: "user.profile.username.label") {
            TextField(
                "user.profile.username.placeholder",
                text:
                    Binding {
                        viewModel.getUsername()
                    } set: {
                        viewModel.updateUsername(with: $0)
                    }
            )
        }
    }
    
    private var ageFieldView: some View {
        FormField(title: "user.profile.age.label") {
            Picker(
                "",
                selection:
                    Binding {
                        viewModel.getAge()
                    } set: {
                        viewModel.updateAge(with: $0)
                    }
            ) {
                ForEach(0..<200, id: \.self) { value in
                    Text(String(value))
                        .tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .labelsHidden()
            .customAccentColorModifier(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
    
    private var heightFieldView: some View {
        FormField(title: "user.profile.height.label") {
            Picker(
                "",
                selection:
                    Binding {
                        viewModel.getHeight()
                    } set: {
                        viewModel.updateHeight(with: $0)
                    }
            ) {
                ForEach(0..<300, id: \.self) { value in
                    Text(String(value))
                        .formattedHeightUnit(.centimeters)
                        .tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .labelsHidden()
            .customAccentColorModifier(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
    
    private var weightFieldView: some View {
        FormField(title: "user.profile.weight.label") {
            Picker(
                "",
                selection:
                    Binding {
                        viewModel.getWeight()
                    } set: {
                        viewModel.updateWeight(with: $0)
                    }
            ) {
                ForEach(0..<400, id: \.self) { value in
                    Text(String(value))
                        .formattedWeightUnit(.kilograms)
                        .tag(value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .labelsHidden()
            .customAccentColorModifier(Constants.Design.Colors.textColorHighEmphasis)
        }
    }
}

#Preview {
    UserProfileView(onSubmit: {_ in }, onDismiss: {}, onLogout: {}, viewModel: UserProfileViewModel())
}
