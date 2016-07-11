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
    
    // MARK: - Actions
    @IBAction func signupButtonTapped(sender: UIButton) {
        
    }
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
    }
    

    // MARK: - Text field end editing
    @IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
