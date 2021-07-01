//
//  SearchUserTableViewController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/29/21.
//

import UIKit
import Firebase
class SearchUserTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let db = Firestore.firestore()
    var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
    }
    
    
    
    func fetchUsers(for searchTerm: String, completion: @escaping ([User]) -> Void) {
        var sortedUsers: [User] = []
        db.collection("users").addSnapshotListener { snapshot, error in
            if let error = error {
                print("did not fetch, sorry (error)")
            }
            if let snapshot = snapshot {
                
                for doc in snapshot.documents {
                    let userData = doc.data()
                    guard let firstName = userData["firstName"] as? String,
                          let lastName = userData["lastName"] as? String else {return}
                    
                    if firstName.lowercased().contains(searchTerm.lowercased()) || lastName.lowercased().contains(searchTerm.lowercased()) {
                        
                        sortedUsers.append(User(firstName: firstName, lastName: lastName))
                    }
                }
                completion(sortedUsers)
            }
        }
    }
    
    
    
}//end of class
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
}

extension SearchUserTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        let user = users[indexPath.row]
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
                return cell
    }
}


extension SearchUserTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ProfileTableViewController else {return}
            let user = self.users[indexPath.row]
            destinationVC.profileUser = user
            
        }
    }
}



