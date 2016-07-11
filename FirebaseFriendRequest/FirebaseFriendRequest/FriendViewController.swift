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
    
    var friendList: [(email: String, id: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataController.dataController.CURRENT_USER_REF.child("friends").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            self.friendList.removeAll()
            self.tableView.reloadData()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                let email = DataController.dataController.emailForUserID(id, completion: { (email) in
                    self.friendList.append((email, id))
                    self.tableView.reloadData()
                })
            }
        })
    }
}

extension FriendViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
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
        cell!.emailLabel.text = friendList[indexPath.row].email
        
        cell!.setFunction {
            let id = self.friendList[indexPath.row].id
            DataController.dataController.removeFriend(id)
        }
        
        // Return cell
        return cell!
    }
    
}