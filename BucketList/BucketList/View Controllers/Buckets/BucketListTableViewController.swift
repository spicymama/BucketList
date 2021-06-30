//
//  BucketListTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/24/21.
//

import UIKit

class BucketListTableViewController: UITableViewController {
    static let shared = BucketListTableViewController()
    var refresh: UIRefreshControl = UIRefreshControl()

    var bucketList: [Bucket] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    

    var sections: [[Bucket]] = [[], []]
    let sectionNames: [String] = ["Public Bucket", "Private Bucket"]

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

        sections = [[], []]
        BucketListTableViewController.bucketList = []
        self.updateViews()
        BucketFirebaseFunctions.fetchBuckets { result in
            for bucket in result {
                print(bucket.isPublic)
                if bucket.isPublic == true {
                    if !self.sections[0].contains(bucket) {
                    self.sections[0].append(bucket)
                    }
                
                    }
                else {
                    if !self.sections[1].contains(bucket) {
                        self.sections[1].append(bucket)
                        print(self.sections[1])
                    }

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
        return sections[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        let cellText = sections[indexPath.section][indexPath.row].title
      
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
