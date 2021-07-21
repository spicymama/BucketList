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
    func searchedUserWasSelected(viewController: UIViewController)
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
            SearchUserTableViewController.delegate?.searchedUserWasSelected(viewController: vc)
        }
    } // End of Did select row
    
} // End of extension
