//
//  NetworkService.swift
//  SweatSketch
//
//  Created by aibaranchikov on 09.05.2024.
//

import Foundation
import SweatSketchSharedModule

class NetworkService {
    static let shared = NetworkService()
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository

    private init() {
        _ = KoinInitializerKt.doInitKoin(baseUrl: "http://0.0.0.0:8080")
        self.authRepository = DIHelper().authRepository
        self.userRepository = DIHelper().userRepository
    }

    @MainActor
    func isLoggedIn() async -> Bool {
        await withCheckedContinuation { continuation in
            authRepository.isLoggedIn { response, error in
                if let response = response {
                    print("NetworkService isLoggedIn response: \(response.boolValue)")
                    continuation.resume(returning: response.boolValue)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }

    @MainActor
    func login(user: UserCredentialModel) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            authRepository.login(userCredential: user.toShared()) { response, error in
                if response != nil {
                    UserSession.shared.checkLoginStatus()
                    continuation.resume(returning: true)
                } else if let error = error {
                    print("NETWORK SERVICE: Login failed with error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @MainActor
    func logout() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            authRepository.logout { response, error in
                if response != nil {
                    UserSession.shared.checkLoginStatus()
                    continuation.resume(returning: true)
                } else if let error = error {
                    print("NETWORK SERVICE: Logout failed with error: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @MainActor
    func createUser(user: UserCredentialModel) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            userRepository.createUser(userCredential: user.toShared()) { response, error in
                DispatchQueue.main.async {
                    if let response = response {
                        continuation.resume(returning: true)
                    } else if let error = error {
                        print("NETWORK SERVICE: User CREATE failed with error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    @MainActor
    func getUserProfile() async throws -> UserProfileModel {
        try await withCheckedThrowingContinuation { continuation in
            userRepository.getUserProfile() { response, error in
                DispatchQueue.main.async {
                    if let response = response {
                        continuation.resume(returning: response.toLocal())
                    } else if let error = error {
                        print("NETWORK SERVICE: User FETCH failed with error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
