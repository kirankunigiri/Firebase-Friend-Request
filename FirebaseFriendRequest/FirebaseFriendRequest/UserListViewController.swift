//
//  UserListViewController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/8/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var userList: [(email: String, id: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = FIRAuth.auth()?.currentUser?.email!
        
        DataController.dataController.USER_REF.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.userList.removeAll()
            self.tableView.reloadData()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let email = child.childSnapshotForPath("email").value as! String
                if email != FIRAuth.auth()?.currentUser?.email! {
                    self.userList.append((email, child.key))
                }
            }
            self.tableView.reloadData()
        })
    }

    @IBAction func logoutButtonTapped(sender: UIButton) {
        DataController.dataController.logoutAccount()
        
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
        return userList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.emailLabel.text = userList[indexPath.row].email
        
        cell!.setFunction {
            let id = self.userList[indexPath.row].id
            DataController.dataController.sendRequestToUser(id)
        }
        
        // Return cell
        return cell!
    }
    
}