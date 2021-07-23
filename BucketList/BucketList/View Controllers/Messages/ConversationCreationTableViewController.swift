//
//  ConversationCreationTableViewController.swift
//  BucketList
//
//  Created by Justin Webster on 6/23/21.
//

import UIKit

class ConversationCreationTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    //MARK: - Outlets
    @IBOutlet weak var user1TextField: UITextField!
    @IBOutlet weak var user2TextField: UITextField!
    @IBOutlet weak var startConversationBtn: UIBarButtonItem!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStartConversationBtn()
        fetchFriends()
        presentSearchController()
        self.tableView.isEditing = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
//        fetchUsers()
    }
    
    //MARK: - Properties
    var users: [User] = []
    var selected: [User] = []

    // Search controller stuff
    var searchController = UISearchController()
    var resultSearchController: UISearchController? = nil

    
    //MARK: - Actions
    
    @IBAction func startConversationButtonTapped(_ sender: Any) {
        guard let user = ConversationController.shared.currentUser else {return}
        ConversationController.shared.createAndSaveConversation(users: selected) { conversation in
            ConversationController.shared.updateUsers(users: self.selected, conversation: conversation) { result in
                switch result {
                case true:
                    print("updated users")
                case false:
                    print("error updating user")
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Functions
    
    func fetchFriends() {
        guard let userID = ConversationController.shared.currentUser?.uid else {return}
        FirebaseFunctions.fetchFriends(friendsListID: userID) { result in
            FirebaseFunctions.fetchUsersData(passedUserIDs: result.friends) { users in
                self.users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateUsers(conversation: Conversation) {
        
    }
    
    func youHaveNoFriends() {
        let alert = UIAlertController(title: "No Friends Found!", message: "Lets go look for them!", preferredStyle: .alert)
        
        let cancelBtn = UIAlertAction(title: "Close", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelBtn)
        
        let startConversationBtn = UIAlertAction(title: "Find some Friends!", style: .default) { _ in
        }
        alert.addAction(startConversationBtn)
        
        present(alert, animated: true, completion: nil)
    } // End of You have no friends
    
    
    func updateStartConversationBtn() {
        if selected.count == 0 {
            self.startConversationBtn.isEnabled = false
            self.startConversationBtn.title = nil
        }
    }
    
    func presentSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        let storyboard: UIStoryboard = UIStoryboard(name: "SearchBar", bundle: nil)
        let userSearchTable = storyboard.instantiateViewController(identifier: "userSearchTable") as! SearchUserTableViewController
        resultSearchController = UISearchController(searchResultsController: userSearchTable)
        resultSearchController?.searchResultsUpdater = userSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Who are we looking for?"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
    }
    
//    func fetchUsers() {
//        guard let friendsList = friendsList?.friends else {return}
//        for friend in friendsList  {
//            FirebaseFunctions.fetchUserData(uid: friend) { friend in
//                self.users.append(friend)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let usersCount = users.count
        
        if usersCount == 0 {
            youHaveNoFriends()
            return 0
        } else {
            return usersCount
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        let friend = users[indexPath.row]
        cell.textLabel?.text = "\(friend.firstName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
    
    func selectDeselectCell(tableView: UITableView, indexPath: IndexPath) {
        selected = []
        guard let selectedCells = tableView.indexPathsForSelectedRows else {return}
        for cell in selectedCells {
            selected.append(users[cell.row])
            self.updateStartConversationBtn()
        }
        selected.append(ConversationController.shared.currentUser!
        )
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
  

}//End of Class
