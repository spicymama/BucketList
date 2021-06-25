//
//  FriendsListTableViewController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/24/21.
//

import UIKit
import Firebase


class FriendsListTableViewController: UITableViewController {
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchFriendsData()
    }
    
    
    //MARK: - Properties
    let uid = Auth.auth().currentUser?.uid
    var friendsList: [String] = []
    var friends: [User] = []
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsListCell", for: indexPath)
        let friend = self.friends
        // Load in friends data
        
        
        return cell
    }

    //MARK: - Functions
    func updateViews() {
        
    }
    
    func fetchFriendsData() {
        FirebaseFunctions.fetchFriends(uid: uid ?? "0") { data in
            self.friendsList = data.friends
        }
        
        FirebaseFunctions.fetchUsersData(passedUserIDs: friendsList) { data in
            self.friends = data
        }
    } // End of Fetch Friends Data
    
} // End of Class
