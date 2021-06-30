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
    
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Firestore.firestore()
    }

   

}//end of class
extension SearchUserTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
}

