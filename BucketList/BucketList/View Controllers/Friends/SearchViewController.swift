//
//  SearchViewController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/28/21.
//

import UIKit
/*
class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let locationSearchTable = storyboard!.instantiateViewController(identifier: "SearchTableViewController") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Where are we going?"
        //navigationItem.titleView = resultSearchController?.searchBar
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    

}//end class

extension SearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
       // request.region = mapView.region
        let search =
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }

  */

