//
//  BucketItTableViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/28/21.
//  Copied heavily off Gavin Woffinden's BucketListTableViewController
//

import UIKit

protocol BucketItDelegate: AnyObject {
    func BucketItPicked(bucketTitle: String, bucketID: String)
}

class BucketItTableViewController: UITableViewController {
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBuckets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Properties
    var buckets: [Bucket] = []
    static var delegate: BucketItDelegate?
    var refresh: UIRefreshControl = UIRefreshControl()
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buckets.count
    }
    
    // Text in each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bucketItemCell", for: indexPath)
        let bucketTitle = buckets[indexPath.row].title
        
        cell.textLabel?.text = bucketTitle
        return cell
    }
    
    // Did Select Row functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bucketTitle = buckets[indexPath.row].title
        let bucketID = buckets[indexPath.row].bucketID
        
        BucketItTableViewController.delegate?.BucketItPicked(bucketTitle: bucketTitle, bucketID: bucketID!)
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    func fetchBuckets() {
        BucketFirebaseFunctions.fetchAllBuckets { data in
            self.buckets = data
            self.tableView.reloadData()
        }
    } // End of Function Load Data
    
} // End of Class Bucket-It VC

