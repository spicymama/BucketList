//
//  BucketListTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/24/21.
//

import UIKit

class BucketListTableViewController: UITableViewController {
    var refresh: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    var sections: [List] = []
    var thePublicList = List(title: "Public List", list: [])
    var thePrivateList = List(title: "Private List", list: [])
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    @objc func loadData() {
        BucketFirebaseFunctions.fetchBuckets { result in
            self.sections = result
            self.updateViews()
        }
    }
    
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

} // End of Class Bucket List Table VC
