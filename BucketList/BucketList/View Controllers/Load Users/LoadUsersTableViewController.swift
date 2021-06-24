//
//  LoadUsersTableViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/22/21.
//

import UIKit

class LoadUsersTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUsersData()
    } // End of View did load
    
    // MARK: - Properties
    var users: [User] = []
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    } // End of Number of rows
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell", for: indexPath)
        let user = self.users[indexPath.row]
        
        // Data to update
        let usersName = (user.firstName + " " + user.lastName)
        
        // Friend count
        let friendCount = user.friendsList?.friends.count
        
        cell.textLabel?.text = usersName
        cell.detailTextLabel?.text = String(friendCount!)
        
        return cell
    } // End of Cell for row at
    
    
    // MARK: - Functions
    func fetchUsersData() {
        FirebaseFunctions.fetchUsersData(passedUserIDs: []) { usersNames in
            self.users = usersNames
            self.tableView.reloadData()
        }
    } // End of Function fetchUsersData
    
} // End of Class LoadUsersTableView
