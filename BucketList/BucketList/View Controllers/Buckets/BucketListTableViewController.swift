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
       // let section = sections[indexPath.row].list
      //  cell.textLabel?.text = section.title
       // cell.detailTextLabel?.text = section.list.first

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
