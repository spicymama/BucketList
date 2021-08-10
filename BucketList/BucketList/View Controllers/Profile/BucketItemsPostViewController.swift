//
//  BucketItemsPostTableViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 8/10/21.
//

import UIKit

class BucketItemsPostViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var bucketTitleLabel: UILabel!
    @IBOutlet weak var bucketItemsTable: UITableView!
    
    
    // MARK: - Properties
    var bucket: Bucket?
    var bucketItems: [BucketItem] = []
    
    // MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bucketItemsTable.delegate = self
        bucketItemsTable.dataSource = self
        
        loadData()
        bucketItemsTable.reloadData()
    } // End of View Did load
    
    
    // MARK: - Functions
    func loadData() {
        BucketFirebaseFunctions.fetchBucketItems(bucketItemsID: bucket?.itemsID ?? "") { FetchedBucketItems in
            self.bucketItems = FetchedBucketItems
            
            self.bucketItemsTable.reloadData()
            
            self.updateView()
        }
    } // End of Function
    
    
    func updateView() {
        bucketTitleLabel.text = bucket?.title
    } // End of Update view
    
    // MARK: - Actions
    @IBAction func toBucketedPostsBtn(_ sender: Any) {
        
    } // End of Action
    
} // End of Class


// MARK: - Extensions
extension BucketItemsPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bucketItemCell", for: indexPath)
        
        let title = bucketItems[indexPath.row].title
        var completed = ""
        if bucketItems[indexPath.row].completed == true {
            completed = "☑︎"
        } else if bucketItems[indexPath.row].completed == false {
            completed = "☐"
        }
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = completed
        
        return cell
    } // End of Cell for Row at
} // End of Extension
