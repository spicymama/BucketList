//
//  BucketItemTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 7/1/21.
//

import UIKit

// MARK: - Protocols
protocol SaveBtnDelegate: AnyObject {
    func toggleSaveBtn(isVisible: Bool)
} // End of Protocol


// MARK: - Class
class BucketItemTableViewController: UITableViewController {
    
    // MARK: - Properties
    static let shared = BucketItemTableViewController()
    var saveBtnDelegate: SaveBtnDelegate?
    
    var bucket: Bucket?
    var bucketItemsArray: [BucketItem] = []
    var bucketItemsID: String? {
        didSet {
            loadData()
        }
    } // End of Items ID Variable
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    // MARK: - Functions
    @objc func loadData() {
        guard let bucketItemsID = bucketItemsID else {return}
        BucketFirebaseFunctions.fetchBucketItems(bucketItemsID: bucketItemsID) { fetchedBucketItems in
            for bucketItem in fetchedBucketItems {
                self.bucketItemsArray.append(bucketItem)
                self.updateViews()
            }
        }
    } // End of Load data
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    } // End of Update views
    
    
    // MARK: - Actions
    @IBAction func addBtn(_ sender: Any) {
        let addItemAlert = UIAlertController(title: "What would you like to add?", message: "To your Bucket: \(bucket!.title)", preferredStyle: .alert)
        
        addItemAlert.addTextField { textField in
            textField.placeholder = "Item Title Here..."
        }
        
        addItemAlert.addTextField { textField in
            textField.placeholder = "Any notes about this item?"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        let saveAction = UIAlertAction(title: "Bucket It!", style: .default) { _ in
            // Save code here
            let bucketID = self.bucket?.bucketID
            guard let itemTitle = addItemAlert.textFields?[0].text, !itemTitle.isEmpty else { return }
            let itemNote = (addItemAlert.textFields?[1].text) ?? ""
            
            let newBucketItem = BucketItem(bucketID: bucketID!, title: itemTitle, note: itemNote, completed: false)
            BucketFirebaseFunctions.createBucketItem(bucketItem: newBucketItem)
        }
        
        addItemAlert.addAction(cancelAction)
        addItemAlert.addAction(saveAction)
        
        self.present(addItemAlert, animated: true, completion: nil)
    } // End of Add Btn
    
    
    // MARK: - Cell Lifecycle
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bucketItemCell", for: indexPath) as? BucketItemTableViewCell else {return UITableViewCell()}
        
        let bucketItem: BucketItem = bucketItemsArray[indexPath.row]
        cell.bucketItem = bucketItem
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bucketItem: BucketItem = bucketItemsArray[indexPath.row]
            
            BucketFirebaseFunctions.deleteBucketItem(bucketItem: bucketItem)
            
            bucketItemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    } // End of Delete
    
    
    
    // MARK: - Keyboard Stuff
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Show save button delegate thing
        saveBtnDelegate?.toggleSaveBtn(isVisible: true)
    }
} // End of Bucket Item Controller
