//
//  UserCell.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/11/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var buttonFunc: (() -> (Void))!
    
    @IBAction func buttonTapped(sender: UIButton) {
        buttonFunc()
    }
    
    func setFunction(function: () -> Void) {
        self.buttonFunc = function
    }
    
}
