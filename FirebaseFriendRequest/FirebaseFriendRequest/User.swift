//
//  User.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/12/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import Foundation

class User {
    
    var email: String!
    var id: String!
    
    init(userEmail: String, userID: String) {
        self.email = userEmail
        self.id = userID
    }
    
}