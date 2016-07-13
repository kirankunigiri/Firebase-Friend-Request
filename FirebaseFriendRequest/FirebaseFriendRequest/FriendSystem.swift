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

class FriendSystem {
    
    static let system = FriendSystem()
    
    // MARK: - Firebase references
    let BASE_REF = FIRDatabase.database().reference()
    let USER_REF = FIRDatabase.database().reference().child("users")
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        let id = FIRAuth.auth()?.currentUser!.uid
        return USER_REF.child("\(id!)")
    }
    
    var CURRENT_USER_FRIENDS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("friends")
    }
    
    var CURRENT_USER_REQUESTS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("requests")
    }
    
    var CURRENT_USER_ID: String {
        let id = FIRAuth.auth()?.currentUser!.uid
        return id!
    }
    
    func getUser(userID: String, completion: (User) -> Void) {
        USER_REF.child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let email = snapshot.childSnapshotForPath("email").value as! String
            let id = snapshot.key
            completion(User(userEmail: email, userID: id))
        })
    }
    
    // MARK: - Account Related
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
    
    // MARK: - Request System Functions
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
    
    // MARK: - All users
    var userList = [User]()
    func addUserObserver(completion: () -> Void) {
        FriendSystem.system.USER_REF.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.userList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let email = child.childSnapshotForPath("email").value as! String
                if email != FIRAuth.auth()?.currentUser?.email! {
                    self.userList.append(User(userEmail: email, userID: child.key))
                }
            }
            completion()
        })
    }
    func removeUserObserver() {
        USER_REF.removeAllObservers()
    }
    
    // MARK: - All friends
    var friendList = [User]()
    func addFriendObserver(completion: () -> Void) {
        CURRENT_USER_FRIENDS_REF.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.friendList.append(user)
                    completion()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                completion()
            }
        })
    }
    func removeFriendObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }
    
    // MARK: - All requests
    var requestList = [User]()
    func addRequestObserver(completion: () -> Void) {
        CURRENT_USER_REQUESTS_REF.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.requestList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.requestList.append(user)
                    completion()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                completion()
            }
        })
    }
    func removeRequestObserver() {
        CURRENT_USER_REQUESTS_REF.removeAllObservers()
    }
    
}



