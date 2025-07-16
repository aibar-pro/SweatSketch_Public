//
//  UserProfileViewModel.swift
//  SweatSketch
//
//  Created by aibaranchikov on 18.07.2024.
//

import Foundation
import SwiftUICore

class UserProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
    @Published var userProfile: UserProfileModel?
    @Published private(set) var isEditingProfile: Bool = false
    @Published var selectedHeightUnit: LengthUnit = .meters
    
    init() {
        Task {
            await MainActor.run {
                selectedHeightUnit = AppSettings.shared.lengthSystem.defaultUnit
            }
            await fetchUserProfile()
        }
    }
    
    private func fetchUserProfile() async {
        defer {
            Task { @MainActor in self.isLoading = false }
        }
        
        do {
            self.userProfile = try await NetworkService.shared.getUserProfile()
//        } catch let error as APIError where error.isOne(of: .notFound()) {
//            print("\(type(of: self)): Profile not found. Creating new one...")
//            await MainActor.run {
//                isEditingProfile = true
//                userProfile = UserProfileModel()
//            }
        } catch {
            print("\(type(of: self)): User profile fetch failed: \(error.localizedDescription)")
            await MainActor.run {
                isEditingProfile = true
                userProfile = UserProfileModel()
            }
        }
    }
    
    func getGreeting() -> String {
        guard let username = userProfile?.username else {
            return ""
        }
        return ", \(username)"
    }
    
    var usernameBinding: Binding<String> {
        .init(
            get: { self.userProfile?.username ?? "" },
            set: { self.userProfile?.username = $0 }
        )
    }
    
    var ageBinding: Binding<Int> {
        .init(
            get: { self.userProfile?.age ?? Constants.DefaultValues.UserProfile.age },
            set: { self.userProfile?.age = $0 }
        )
    }
    
    var heightBinding: Binding<Double> {
        .init(
            get: { self.userProfile?.height ?? Constants.DefaultValues.UserProfile.height },
            set: { self.userProfile?.height = $0 }
        )
    }
    
    var weightBinding: Binding<Double> {
        .init(
            get: { self.userProfile?.weight ?? Constants.DefaultValues.UserProfile.weight },
            set: { self.userProfile?.weight = $0 }
        )
    }
}
