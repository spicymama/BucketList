//
//  LoadUsersTableViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/22/21.
//

import UIKit

class LoadUsersTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUsersData()
    } // End of View did load

    
    // MARK: - Properties
    var usersData: [String] = []
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersData.count
    } // End of Number of rows
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell", for: indexPath)
        let userData = self.usersData[indexPath.row]
        
        cell.textLabel?.text = userData
        
        return cell
    } // End of Cell for row at
    
    
    // MARK: - Functions
    func fetchUsersData() {
        FirebaseFunctions.fetchUsersData { usersData in
            self.usersData = usersData
            self.tableView.reloadData()
        }
    } // End of Function fetchUsersData

} // End of Class LoadUsersTableView
