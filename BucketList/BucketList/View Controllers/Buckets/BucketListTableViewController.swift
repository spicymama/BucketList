//
//  BucketListTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/24/21.
//

import UIKit
import FirebaseAuth

class BucketListTableViewController: UITableViewController {
    
    // MARK: - Properties
    static let shared = BucketListTableViewController()
    var refresh: UIRefreshControl = UIRefreshControl()
    
    var bucketsList: [Bucket] = []
    let sectionNames: [String] = ["Public Bucket", "Private Bucket"]
    
    var thePublicList: [Bucket] = []
    var thePrivateList: [Bucket] = []
    
    var sections: [[Bucket]] = [[], []]

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    } // End of View did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    } // End of View will appear
    
    
    // MARK: - Functions
    
    func setupView() {
        fetchBuckets()
        tableView.addSubview(refresh)
    } // End of Setup Views
    
    func updateView() {
        tableView.reloadData()
    }
    
    func fetchBuckets() {
        bucketsList = []
        guard let userID = Auth.auth().currentUser?.uid else { return }
        BucketFirebaseFunctions.fetchAllBucketsForUser(userID: userID) { fetchedBuckets in
            for bucket in fetchedBuckets {
                self.bucketsList.append(bucket)
                self.updateSections()
            }
        }
    } // End of Load Data
    
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
            updateView()
        }
    } // End of Update sections
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bucketToDelete = sections[indexPath.section][indexPath.row].bucketID
            BucketFirebaseFunctions.deleteBucket(bucketID: bucketToDelete!) { result in
                DispatchQueue.main.async {
                    switch result {
                    case true:
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
                        self.setupView()
                        self.tableView.reloadData()
                    case false:
                        print("Error deleting bucket")
                    }
                }
            }
        }
    }
    
    // MARK: - Table View
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
    
} // End of Class Bucket List Table VC
