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
        let id = FIRAuth.auth()?.currentUser!.uid
        return USER_REF.child("\(id!)")
    }
    
    var CURRENT_USER_ID: String {
        let id = FIRAuth.auth()?.currentUser!.uid
        return id!
    }
    
    func createAccount(email: String, password: String, completion: (success: Bool) -> Void) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            
            if (error == nil) {
                // Success
                var userInfo = [String: AnyObject]()
                userInfo = ["email": user!.email!]
                self.CURRENT_USER_REF.setValue(userInfo)
                completion(success: true)
            } else {
                // Failure
                completion(success: false)
            }
            
        })
    }
    
    func loginAccount(email: String, password: String, completion: (success: Bool) -> Void) {
        print("logging in user")
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            
            if (error == nil) {
                // Success
                completion(success: true)
            } else {
                // Failure
                completion(success: false)
                print(error)
            }
            
        })
    }
    
    func logoutAccount() {
        try! FIRAuth.auth()?.signOut()
    }
    
    func sendRequestToUser(userID: String) {
        USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).setValue(true)
    }
    
    func removeFriend(userID: String) {
        CURRENT_USER_REF.child("friends").child(userID).removeValue()
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).removeValue()
    }
    
    func acceptFriendRequest(userID: String) {
        CURRENT_USER_REF.child("requests").child(userID).removeValue()
        CURRENT_USER_REF.child("friends").child(userID).setValue(true)
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).setValue(true)
        USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).removeValue()
    }
    
    func emailForUserID(userID: String, completion: (email: String) -> Void) {
        USER_REF.child(userID).child("email").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            completion(email: snapshot.value as! String)
        })
    }
        
}