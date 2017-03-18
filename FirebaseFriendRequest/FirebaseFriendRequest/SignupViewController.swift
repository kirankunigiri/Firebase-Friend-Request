//
//  SignupViewController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/8/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var signupEmailField: UITextField!
    @IBOutlet weak var signupPasswordField: UITextField!
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        
        let email = signupEmailField.text!
        let password = signupPasswordField.text!
        
        if email != "" && password.characters.count >= 6 {
            FriendSystem.system.createAccount(email, password: password, name: "Name") { (success) in
                if success {
                    self.performSegue(withIdentifier: "signupCompleteSegue", sender: self)
                } else {
                    // Error
                    self.presentSignupAlertView()
                }
            }
        } else {
            // Fields not filled
            presentSignupAlertView()
        }
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let email = loginEmailField.text!
        let password = loginPasswordField.text!
        
        if email != "" && password.characters.count >= 6 {
            FriendSystem.system.loginAccount(email, password: password) { (success) in
                if success {
                    self.performSegue(withIdentifier: "signupCompleteSegue", sender: self)
                } else {
                    // Error
                    self.presentSignupAlertView()
                }
            }
        } else {
            // Fields not filled
            presentSignupAlertView()
        }
    }
    
    func presentSignupAlertView() {
        let alertController = UIAlertController(title: "Error", message: "Couldn't create account", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentLoginAlertView() {
        let alertController = UIAlertController(title: "Error", message: "Email/password is incorrect", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Text field end editing
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
