//
//  BucketItTableViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/28/21.
//  Copied heavily off Gavin Woffinden's BucketListTableViewController
//

import UIKit

class BucketItTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    let sections: [List] = [List(title: "Public List", list: ["Jump really high", "Ride the tallest rollercoaster", "Try to eat surstromming"]), List(title: "Private List", list: ["Ride in a hot air balloon", "Touch a whale", "Drive a Lambo"])]
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.title
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        let cellText = sections[indexPath.section].list[indexPath.row]
        cell.textLabel?.text = cellText
        return cell
    }
} // End of Class Bucket It VC
