//
//  Error.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/24/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import Foundation
import FirebaseAuth

class Error {
    
    var errorMessage: String!
    
    init(error: AuthErrorCode) {
        switch error {
            
        case .invalidEmail:
            errorMessage = "Whoops! That's not a valid email!"
            
        case .userDisabled:
            errorMessage = "This user is blocked."
            
        case .wrongPassword:
            errorMessage = "Looks like the email or password is incorrect!"
            
        case .emailAlreadyInUse:
            errorMessage = "There's already an account with this email!"
            
        case .weakPassword:
            errorMessage = "The password is too weak. Try something stronger!"
            
        default:
            errorMessage = "Looks like something went wrong. Please try again!"
        }
    }
    
}
