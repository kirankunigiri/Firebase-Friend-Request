//
//  DataController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/10/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class DataController {
    
    static let dataController = DataController()
    
    let BASE_REF = FIRDatabase.database().reference()
    let USER_REF = FIRDatabase.database().reference().child("users")
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        return BASE_REF.child("\(FIRAuth.auth()?.currentUser?.uid)")
    }
        
}