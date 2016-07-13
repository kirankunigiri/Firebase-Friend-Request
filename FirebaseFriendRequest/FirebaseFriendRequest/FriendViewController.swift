//
//  FriendViewController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/8/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit
import Firebase

class FriendViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FriendSystem.system.addFriendObserver {
            self.tableView.reloadData()
        }
    }
}

extension FriendViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.friendList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.button.setTitle("Remove", forState: .Normal)
        cell!.emailLabel.text = FriendSystem.system.friendList[indexPath.row].email
        
        cell!.setFunction {
            let id = FriendSystem.system.friendList[indexPath.row].id
            FriendSystem.system.removeFriend(id)
        }
        
        // Return cell
        return cell!
    }
    
}