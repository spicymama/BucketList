//
//  BucketListTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/24/21.
//

import UIKit

class BucketListTableViewController: UITableViewController {

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
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
/*
 for section in sections {
     if section.title == "Public List" {
         let section = sections[0]
         cell.textLabel?.text = section.list[indexPath.row]
     }
     else if section.title == "Private List" {
         let section = sections[1]
// let items = section.list[indexPath.row]
 cell.textLabel?.text = section.list[indexPath.row]
 //cell.detailTextLabel?.text = section.list.first
 }
 }
 */
