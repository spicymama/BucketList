//
//  FriendsListTableViewController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/24/21.
//

import UIKit
import Firebase


class FriendsListTableViewController: UITableViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchFriendsData()
       
    }
    
    //MARK: - Properties
    let db = Firestore.firestore()
    let friends = [Friend]

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsListCell", for: indexPath)
        let friend = self.friendlists

        
        return cell
    }
    






//MARK: - Functions
    
    func fetchFriendsData() {
        FirebaseFunctions.fetchFriends(uid: uid, 🐶: <#T##(FriendsList) -> Void#>)
    }
    
   
    

}
