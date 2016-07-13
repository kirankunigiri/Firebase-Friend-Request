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
    /** The base Firebase reference */
    let BASE_REF = FIRDatabase.database().reference()
    /* The user Firebase reference */
    let USER_REF = FIRDatabase.database().reference().child("users")
    
    /** The Firebase reference to the current user tree */
    var CURRENT_USER_REF: FIRDatabaseReference {
        let id = FIRAuth.auth()?.currentUser!.uid
        return USER_REF.child("\(id!)")
    }
    
    /** The Firebase reference to the current user's friend tree */
    var CURRENT_USER_FRIENDS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("friends")
    }
    
    /** The Firebase reference to the current user's friend request tree */
    var CURRENT_USER_REQUESTS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("requests")
    }
    
    /** The current user's id */
    var CURRENT_USER_ID: String {
        let id = FIRAuth.auth()?.currentUser!.uid
        return id!
    }

    
    /** Gets the current User object for the specified user id */
    func getCurrentUser(completion: (User) -> Void) {
        CURRENT_USER_REF.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let email = snapshot.childSnapshotForPath("email").value as! String
            let id = snapshot.key
            completion(User(userEmail: email, userID: id))
        })
    }
    /** Gets the User object for the specified user id */
    func getUser(userID: String, completion: (User) -> Void) {
        USER_REF.child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let email = snapshot.childSnapshotForPath("email").value as! String
            let id = snapshot.key
            completion(User(userEmail: email, userID: id))
        })
    }
    
    
    
    // MARK: - Account Related
    
    /**
     Creates a new user account with the specified email and password
     - parameter completion: What to do when the block has finished running. The success variable 
     indicates whether or not the signup was a success
     */
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
    
    /**
     Logs in an account with the specified email and password
     
     - parameter completion: What to do when the block has finished running. The success variable
     indicates whether or not the login was a success
     */
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
    
    /** Logs out an account */
    func logoutAccount() {
        try! FIRAuth.auth()?.signOut()
    }
    
    
    
    // MARK: - Request System Functions
    
    /** Sends a friend request to the user with the specified id */
    func sendRequestToUser(userID: String) {
        USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).setValue(true)
    }
    
    /** Unfriends the user with the specified id */
    func removeFriend(userID: String) {
        CURRENT_USER_REF.child("friends").child(userID).removeValue()
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).removeValue()
    }
    
    /** Accepts a friend request from the user with the specified id */
    func acceptFriendRequest(userID: String) {
        CURRENT_USER_REF.child("requests").child(userID).removeValue()
        CURRENT_USER_REF.child("friends").child(userID).setValue(true)
        USER_REF.child(userID).child("friends").child(CURRENT_USER_ID).setValue(true)
        USER_REF.child(userID).child("requests").child(CURRENT_USER_ID).removeValue()
    }
    
    
    
    // MARK: - All users
    /** The list of all users */
    var userList = [User]()
    /** Adds a user observer. The completion function will run every time this list changes, allowing you  
     to update your UI. */
    func addUserObserver(update: () -> Void) {
        FriendSystem.system.USER_REF.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.userList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let email = child.childSnapshotForPath("email").value as! String
                if email != FIRAuth.auth()?.currentUser?.email! {
                    self.userList.append(User(userEmail: email, userID: child.key))
                }
            }
            update()
        })
    }
    /** Removes the user observer. This should be done when leaving the view that uses the observer. */
    func removeUserObserver() {
        USER_REF.removeAllObservers()
    }
    
    
    
    // MARK: - All friends
    /** The list of all friends of the current user. */
    var friendList = [User]()
    /** Adds a friend observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addFriendObserver(update: () -> Void) {
        CURRENT_USER_FRIENDS_REF.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.friendList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend observer. This should be done when leaving the view that uses the observer. */
    func removeFriendObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }
    
    
    
    // MARK: - All requests
    /** The list of all friend requests the current user has. */
    var requestList = [User]()
    /** Adds a friend request observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addRequestObserver(update: () -> Void) {
        CURRENT_USER_REQUESTS_REF.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.requestList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.requestList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend request observer. This should be done when leaving the view that uses the observer. */
    func removeRequestObserver() {
        CURRENT_USER_REQUESTS_REF.removeAllObservers()
    }
    
}



