//
//  NewBucketTableViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/28/21.
//

import UIKit

class NewBucketTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var bucketTitleField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    
    // MARK: - Properties
    var bucket: Bucket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Big function here
        let itemsCount: Int = 0
        
        return itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the Bucket Item name, and it's completion status as a toggle button?
        let cell = tableView.dequeueReusableCell(withIdentifier: "bucketItemCell", for: indexPath)
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func newItemBtn(_ sender: Any) {
        
    }
    
    @IBAction func visibilitySwitch(_ sender: Any) {
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // "toNewBucketItemVC"
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

} // End of Class New Bucket VC
