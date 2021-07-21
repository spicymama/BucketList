//
//  SearchUserTableViewController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/29/21.
//

import UIKit
import Firebase


class SearchUserTableViewController: UITableViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    let db = Firestore.firestore()
    var users: [User] = []

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
                    let userData = doc.data()
                    guard let firstName = userData["firstName"] as? String,
                          let lastName = userData["lastName"] as? String else {return}
                    
                    if firstName.lowercased().contains(searchTerm.lowercased()) || lastName.lowercased().contains(searchTerm.lowercased()) {
                        
                        sortedUsers.append(User(firstName: firstName, lastName: lastName))
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "profileDetailVC") as? ProfileViewController else { return }
        let selectedUser: User = users[indexPath.row]
        
        vc.profileUser = selectedUser
        dismiss(animated: true) {
            let feedStoryboard = UIStoryboard(name: "gavin", bundle: nil)
            guard let feedVC = feedStoryboard.instantiateViewController(identifier: "FeedTableVC") as? FeedTableViewController else { return }
//            self.navigationController?.pushViewController(feedVC, animated: true)
//            feedVC.navigationController?.pushViewController(feedVC, animated: true)
//            self.navigationController?.popToViewController(feedVC, animated: true)
//            feedVC.navigationController?.popToViewController(feedVC, animated: true)
            self.present(feedVC, animated: true, completion: nil)
            print("Is line \(#line) working?")
        }
        /*
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "profileDetailVC")
        self.navigationController?.pushViewController(vc, animated: true)
        
        let storyboardName = "ProfileDetail"
        let vcName = "profileDetailVC"
        
        let selectedUser: User = users[indexPath.row]

        SearchUserTableViewController.delegate?.pushVC(storyboardName: storyboardName, vcName: vcName, userData: selectedUser)
        */
    } // End of Did select row
} // End of extension
