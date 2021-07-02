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
        bucketList = []
        self.updateViews()
        BucketFirebaseFunctions.fetchBuckets { result in
            for bucket in result {
                if bucket.isPublic == true {
                    if !self.sections[0].contains(bucket) {
                    self.sections[0].append(bucket)
                    }
                
                    }
                else {
                    if !self.sections[1].contains(bucket) {
                        self.sections[1].append(bucket)
                    }

                }
            }
            self.updateViews()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bucketToDelete = sections[indexPath.section][indexPath.row].bucketID
            print(bucketToDelete)
            BucketFirebaseFunctions.deleteBucket(bucketID: bucketToDelete) { result in
                DispatchQueue.main.async {
                switch result {
                case true:
                    print("deleted bucket from firestore")
                    /*
                    for bucket in self.bucketList {
                        if bucket.bucketID == bucketToDelete {
                            guard let index = self.bucketList.firstIndex(of: bucket) else {return}
                            self.bucketList.remove(at: index)
                        }
                    }
                    self.sections.remove(at: [indexPath.section][indexPath.row])
 */
                    //self.tableView.deleteRows(at: [indexPath], with: .fade)
                    self.loadData()
                    self.tableView.reloadData()
                case false:
                     print("Error deleting bucket")
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let section = self.sectionNames[section]
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? BucketItemTableViewController else {return}
            let itemsID = sections[indexPath.section][indexPath.row].itemsID
            print(itemsID)
            destinationVC.itemsID = itemsID
        }
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
