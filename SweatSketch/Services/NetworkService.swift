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
    
    func login(user: UserCredentialModel, completion: @escaping (Result<AuthTokenModel, Error>) -> Void) {
        authRepository.login(userCredential: user.toShared()) { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    completion(.success(response.toLocal()))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func createUser(user: UserCredentialModel, completion: @escaping (Result<ResponseMessageModel, Error>) -> Void) {
        userRepository.createUser(userCredential: user.toShared()) { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    completion(.success(response.toLocal()))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func createUserProfile(userProfile: UserProfileModel, completion: @escaping (Result<ResponseMessageModel, Error>) -> Void) {
        userRepository.createUserProfile(userProfile: userProfile.toShared()) { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    completion(.success(response.toLocal()))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
}
