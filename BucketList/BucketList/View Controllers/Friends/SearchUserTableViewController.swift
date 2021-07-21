//
//  SearchUserTableViewController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/29/21.
//

import UIKit
import Firebase


// MARK: - Protocols
protocol SearchedUserWasSelectedDelegate: AnyObject {
    func searchedUserWasSelected(selectedUserID: String)
} // End of Protocol


// MARK: - Class
class SearchUserTableViewController: UITableViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    let db = Firestore.firestore()
    var users: [User] = []
    static var delegate: SearchedUserWasSelectedDelegate?
    

    // MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    } // End of View Did Load
    
    
    // MARK: - Functions
    func fetchUsers(for searchTerm: String, completion: @escaping ([User]) -> Void) {
        var sortedUsers: [User] = []
        
        db.collection("users").addSnapshotListener { snapshot, error in
            if let error = error {
                print("did not fetch, sorry \(error)")
            }
            if let snapshot = snapshot {
                
                for doc in snapshot.documents {
                    let data = doc.data()
                    
                    let firstName: String = data["firstName"] as? String ?? "First Name"
                    let lastName: String = data["lastName"] as? String ?? "Last Name"
                    let username: String = data["username"] as? String ?? "User Name"
                    let uid: String = data["uid"] as? String ?? "uid"
                    let profilePicURL = data["profilePicUrl"] as? String ?? "defaultProfileImage"
                    let friendsListID: String = data["friendsID"] as? String ?? "You have no friends"
                    
                    if firstName.lowercased().contains(searchTerm.lowercased()) || lastName.lowercased().contains(searchTerm.lowercased()) {
                        
                        let fetchedUser = User(firstName: firstName, lastName: lastName, username: username, profilePicUrl: profilePicURL, uid: uid, friendsListID: friendsListID)
                        
                        sortedUsers.append(fetchedUser)
                    }
                    self.users = sortedUsers
                }
                completion(sortedUsers)
            }
        }
    } // End of FetchUsers
    
}//end of class


// MARK: - Extensions
extension SearchUserTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {return}
        fetchUsers(for: searchBarText) { users in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
} // End of Extension

extension SearchUserTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        let user = users[indexPath.row]
        
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        
        return cell
    } // End of Cell for row at
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUserID: String = users[indexPath.row].uid

        dismiss(animated: true) {
            let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC") as? ProfileViewController else {return}
            
            FirebaseFunctions.fetchUserData(uid: selectedUserID) { fetchedUser in
                vc.profileUser = fetchedUser
                SearchUserTableViewController.delegate?.searchedUserWasSelected(selectedUserID: selectedUserID)
            } // End of Fetch user data
        }
    } // End of Did select row
    
} // End of extension
