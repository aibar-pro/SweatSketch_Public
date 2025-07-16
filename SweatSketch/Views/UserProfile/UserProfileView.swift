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
        VStack(alignment: .leading, spacing: Constants.Design.spacing * 2) {
            Text("user.profile.greeting\(viewModel.getGreeting())!")
                .fullWidthText(.title, alignment: .center)
            
            if viewModel.isEditingProfile {
                profileEditView
            } else {
                Text("")
            }
        }
    }
    
    let numberFieldWidth: CGFloat = 75
    
    private var profileEditView: some View {
        VStack(alignment: .leading, spacing: Constants.Design.spacing) {
            VStack(alignment: .leading, spacing: Constants.Design.spacing) {
                usernameFieldView
                
                ageFieldView
                
                heightFieldView
                
                weightFieldView
            }
            .padding(Constants.Design.spacing)
            .materialBackground()
            .lightShadow()
            
            RectangleButton(
                "app.button.save.label",
                style: .primary,
                isFullWidth: true,
                action: {
                    guard let userProfile = viewModel.userProfile else { return }
                    onSubmit(userProfile)
                }
            )
        }
    }
    
    private var usernameFieldView: some View {
        FormField(title: "user.profile.username.label") {
            TextField(
                "user.profile.username.placeholder",
                text: viewModel.usernameBinding
            )
        }
    }
    
    private var ageFieldView: some View {
        FormField(title: "user.profile.age.label", contentMaxWidth: numberFieldWidth) {
            IntegerTextField(value: viewModel.ageBinding)
        }
    }
    
    private var heightFieldView: some View {
        HStack(alignment: .lastTextBaseline, spacing: Constants.Design.spacing / 4) {
            FormField(title: "user.profile.height.label", contentMaxWidth: numberFieldWidth) {
                DecimalTextField(value: viewModel.heightBinding)
                    .adaptiveTint(Constants.Design.Colors.elementFgPrimary)
            }
            
            Picker("", selection: $viewModel.selectedHeightUnit) {
                ForEach(AppSettings.shared.lengthSystem.allowedUnits, id: \.id) { unit in
                    Text(unit.localizedName).tag(unit)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .adaptiveTint(Constants.Design.Colors.elementFgHighEmphasis)
        }
    }
    
    private var weightFieldView: some View {
        FormField(title: "user.profile.weight.label", contentMaxWidth: numberFieldWidth) {
            DecimalTextField(value: viewModel.weightBinding)
                .adaptiveTint(Constants.Design.Colors.elementFgPrimary)
        }
    }
}

#Preview {
    UserProfileView(
        onSubmit: {_ in },
        onDismiss: {},
        onLogout: {},
        viewModel: UserProfileViewModel()
    )
}
