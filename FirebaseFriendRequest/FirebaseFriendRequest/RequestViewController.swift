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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.button.setTitle("Accept", for: UIControlState())
        cell!.emailLabel.text = FriendSystem.system.requestList[indexPath.row].email
        
        cell!.setFunction {
            let id = FriendSystem.system.requestList[indexPath.row].id
            FriendSystem.system.acceptFriendRequest(id!)
        }
        
        // Return cell
        return cell!
    }
    
}
