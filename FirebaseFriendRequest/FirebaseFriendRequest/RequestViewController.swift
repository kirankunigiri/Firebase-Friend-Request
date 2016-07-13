//
//  RequestViewController.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/8/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FriendSystem.system.requestList)

        FriendSystem.system.addRequestObserver {
            print(FriendSystem.system.requestList)
            self.tableView.reloadData()
        }
    }

}

extension RequestViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.requestList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.button.setTitle("Accept", forState: .Normal)
        cell!.emailLabel.text = FriendSystem.system.requestList[indexPath.row].email
        
        cell!.setFunction {
            let id = FriendSystem.system.requestList[indexPath.row].id
            FriendSystem.system.acceptFriendRequest(id)
        }
        
        // Return cell
        return cell!
    }
    
}