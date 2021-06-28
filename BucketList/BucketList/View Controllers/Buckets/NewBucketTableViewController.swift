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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    // MARK: - Actions
    
    @IBAction func newItemBtn(_ sender: Any) {
    }
    
    @IBAction func visibilitySwitch(_ sender: Any) {
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // "toNewBucketItemVC"
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

} // End of Class New Bucket VC
