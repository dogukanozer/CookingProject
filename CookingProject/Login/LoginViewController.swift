//
//  ViewController.swift
//  CookingProject
//
//  Created by Macbook Air on 14.05.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    // MARK: - Properties
        private let viewModel = LoginViewModel()
        
        // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureRecognizer()
        addDelegates()
        
    }

    @IBAction func signUpButton(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text else {
                    makeAlert(tittleInput: "Error", messegaInput: "Please enter a valid email or password.")
                    return
                }
                
                viewModel.createUser(email: email, password: password)
    }
    
    @IBAction func signİnButton(_ sender: Any) {
        guard let email = emailText.text, let password = passwordText.text else {
                    makeAlert(tittleInput: "ERROR", messegaInput: "Please check your login information.")
                    return
                }
                
                viewModel.signIn(email: email, password: password)
    }
    
    @IBAction func didTapSkipButton(_ sender: Any) {
    }
}
// MARK: - Helpers
private extension LoginViewController {
    
    func makeAlert(tittleInput: String, messegaInput: String) {
        let alert = UIAlertController(title: tittleInput, message: messegaInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func addDelegates() {
        viewModel.delegate = self
    }
    func addGestureRecognizer() {
          let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
          view.addGestureRecognizer(gestureRecognizer)
      }
      
      @objc func hideKeyboard() {
          view.endEditing(true)
      }
  }

  // MARK: - LoginViewModelDelegate
  extension LoginViewController: LoginViewModelDelegate {
      
      func didSignInSuccess() {
          // Bir sonraki sayfaya geçiş yapılmalı.
          print("didSignInSuccess")
      }
      
      func didSignInFail(message: String) {
          makeAlert(tittleInput: "Error", messegaInput: message)
      }
      
      func didCreateSuccess() {
          makeAlert(tittleInput: "Success", messegaInput: "Congratulations, your registration has been successfully done. You can login.")
      }
      
      func didCreateFail(message: String) {
          makeAlert(tittleInput: "Error", messegaInput: message)
      }
  }