//
//  BucketListTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/24/21.
//  Heavily redone by Ethan Andersen in August 2021
//

import UIKit
import FirebaseAuth

class BucketListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var bucketsList: [Bucket] = []

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    } // End of View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBuckets()
    } // End of View will appear
    
    
    // MARK: - Functions
    func fetchBuckets() {
        bucketsList = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        BucketFirebaseFunctions.fetchAllBucketsForUser(userID: userID) { FetchedBuckets in
            self.bucketsList = FetchedBuckets
            self.tableView.reloadData()
        }
    } // End of Load Data

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let bucketToDelete = bucketsList[indexPath.row]
        
        bucketsList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        BucketFirebaseFunctions.deleteBucket(bucketID: bucketToDelete.bucketID!) { Bool in
            if Bool == true {
                print("Bucket deleted from Firebase")
            }
        } // End of Delete bucket firebase function
        
    } // End of Delete

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bucketCell", for: indexPath)
        let bucket = bucketsList[indexPath.row]
        
        cell.textLabel?.text = bucket.title
        //TODO(ethan) Make this change colors based on how much is done
        cell.detailTextLabel?.text = (String(bucket.completion) + "%")
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? BucketItemTableViewController else {return}
            let itemsID = bucketsList[indexPath.row].itemsID
            let bucket = bucketsList[indexPath.row]
            destinationVC.bucketID = bucket.bucketID
            destinationVC.bucket = bucket
            destinationVC.bucketItemsID = itemsID
        }
    }
    
} // End of Class Bucket List Table VC



// Partial Implimentation of public and private lists
/*
class BucketListTableViewController: UITableViewController {
    
    // MARK: - Properties
    static let shared = BucketListTableViewController()

    
    var bucketsList: [Bucket] = []
    // Partial implimentation of public and private lists - Not working too well...
//    let sectionNames: [String] = ["Public Bucket", "Private Bucket"]
    
//    var thePublicList: [Bucket] = []
//    var thePrivateList: [Bucket] = []
    
//    var sections: [[Bucket]] = []

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBuckets()
    } // End of View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBuckets()
    } // End of View will appear
    
    
    // MARK: - Functions
    func fetchBuckets() {
        bucketsList = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        BucketFirebaseFunctions.fetchAllBucketsForUser(userID: userID) { FetchedBuckets in
            let fetchedBuckets = FetchedBuckets
            for bucket in fetchedBuckets {
                self.bucketsList.append(bucket)
//                self.updateSections()
                
                self.tableView.reloadData()
            }
        }
    } // End of Load Data
    /*
    func updateSections() {
        sections = [[], []]
        for bucket in bucketsList {
            if bucket.isPublic == true {
                if !self.sections[0].contains(bucket) {
                    self.sections[0].append(bucket)
                }
            } else {
                if !self.sections[1].contains(bucket) {
                    self.sections[1].append(bucket)
                }
            }
        }
    } // End of Update sections
    */
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let bucketToDelete = sections[indexPath.section][indexPath.row]
        
        BucketFirebaseFunctions.deleteBucket(bucketID: bucketToDelete.bucketID!) { Bool in
            if Bool == true {
                self.fetchBuckets()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } // End of Delete bucket firebase function
        
    } // End of Delete
    
    
    // MARK: - Table View
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sectionNames[section]
        return section
    }
    */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bucketCell", for: indexPath)
        let bucket = sections[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = bucket.title
        //TODO(ethan) Make this change colors based on how much is done
        cell.detailTextLabel?.text = (String(bucket.completion) + "%")
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? BucketItemTableViewController else {return}
            let itemsID = sections[indexPath.section][indexPath.row].itemsID
            let bucket = bucketsList[indexPath.row]
            destinationVC.bucketID = bucket.bucketID
            destinationVC.bucket = bucket
            destinationVC.bucketItemsID = itemsID
        }
    }
    
} // End of Class Bucket List Table VC
*/
