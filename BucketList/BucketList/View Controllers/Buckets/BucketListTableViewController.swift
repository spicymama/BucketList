//
//  BucketListTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/24/21.
//

import UIKit

class BucketListTableViewController: UITableViewController {
    var refresh: UIRefreshControl = UIRefreshControl()
    var bucketList: [Bucket] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    let sections: [List] = [List(title: "Public List", list: []), List(title: "Private List", list: []) ]
    var thePublicList: [Bucket] = []
    var thePrivateList: [Bucket] = []
    
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
            for bucket in result {
                if bucket.isPublic == true {
                    self.sections[0].list.append(bucket.title)
                }
                else if bucket.isPublic == false {
                    self.sections[1].list.append(bucket.title)
                }
            }
            self.updateViews()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section].title
        return section
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
