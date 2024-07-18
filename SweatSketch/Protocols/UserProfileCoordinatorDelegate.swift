//
//  UserProfileCoordinatorDelegate.swift
//  SweatSketch
//
//  Created by aibaranchikov on 27.06.2024.
//

import Foundation

protocol UserProfileCoordinatorDelegate: AnyObject {
    func didRequestLogin()
    func didRequestProfile()
    func didRequestSignup()
    func didRequestLogout()
    func didRequestReturn()
    func didLoginSuccessfully()
    func didSignupSuccessfully()
}
