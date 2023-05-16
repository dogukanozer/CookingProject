//
//  LoginViewModel.swift
//  CookingProject
//
//  Created by Macbook Air on 14.05.2023.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelDelegate: AnyObject {
    func didSignInSuccess()
    func didSignInFail(message: String)
    func didCreateSuccess()
    func didCreateFail(message: String)
}

class LoginViewModel {
    
    // MARK: - Delegate
    weak var delegate: LoginViewModelDelegate?
    
    func signIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                self.delegate?.didSignInFail(message: error.localizedDescription)
                return
            }
            
            self.delegate?.didSignInSuccess()
        }
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                self.delegate?.didCreateFail(message: error.localizedDescription)
                return
            }
            
            self.delegate?.didCreateSuccess()
        }
    }
}
