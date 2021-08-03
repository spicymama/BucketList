//
//  FriendsListTableViewController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/24/21.
//

import UIKit
import Firebase


class FriendsListTableViewController: UITableViewController {
    
    //MARK: - Properties
    let uid = Auth.auth().currentUser?.uid
    var friendsList: [String] = []
    var friends: [User] = []
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchFriendsData()
    } // End of View Did Load
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
        
    } // End of Number of rows
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendsListCell", for: indexPath) as? FriendsListTableViewCell else {return UITableViewCell()}
        let friend = self.friends[indexPath.row]
        cell.user = friend
        
        return cell
    } // End of Cell for row at
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ProfileViewController else {return}
            let friend = self.friends[indexPath.row]
            destinationVC.profileUser = friend
            
        }
    } // End of Segue
    

    //MARK: - Functions
    func fetchFriendsData() {
        FirebaseFunctions.fetchFriends(friendsListID: uid ?? "0") { data in
            for friend in data.friends {
                self.friendsList.append(friend)
            }
            FirebaseFunctions.fetchUsersData(passedUserIDs: self.friendsList) { data in
                for friend in data {
                    self.friends.append(friend)
                                    }
                self.tableView.reloadData()
            }
        }
    } // End of Fetch Friends Data
    
} // End of Class
