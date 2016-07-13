//
//  UserListViewController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/8/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FriendSystem.system.getCurrentUser { (user) in
            self.usernameLabel.text = user.email
        }
        
        FriendSystem.system.addUserObserver { () in
            self.tableView.reloadData()
        }
    }

    @IBAction func logoutButtonTapped(sender: UIButton) {
        FriendSystem.system.logoutAccount()
        
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootVC = appDelegate.window!.rootViewController
        
        if rootVC == self.tabBarController {
            self.presentViewController((storyboard?.instantiateInitialViewController())!, animated: true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
}

extension UserListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.userList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.emailLabel.text = FriendSystem.system.userList[indexPath.row].email
        
        cell!.setFunction {
            let id = FriendSystem.system.userList[indexPath.row].id
            FriendSystem.system.sendRequestToUser(id)
        }
        
        // Return cell
        return cell!
    }
    
}