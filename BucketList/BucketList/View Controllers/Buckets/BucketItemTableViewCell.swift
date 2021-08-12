//
//  BucketItemTableViewCell.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/8/21.
//

import UIKit

// MARK: - Class
class BucketItemTableViewCell: UITableViewCell, UITextFieldDelegate {
    static let shared = BucketItemTableViewCell()
    
    // MARK: - Outlets
    @IBOutlet weak var bucketItemTitleField: UITextField!
    @IBOutlet weak var bucketItemTimestampLabel: UILabel!
    @IBOutlet weak var completedBtn: UIButton!
    
    var isCompleted: Bool?
    var selectedCell: UITableViewCell?
    var bucketItemsArr: [BucketItem] = []
    
    
    // MARK: - Properties
    var bucketItem: BucketItem? {
        didSet {
            bucketItemTitleField.delegate = self
            updateView()
        }
    } // End of Bucket Item
    
    
    // MARK: - Functions
    func updateView() {
        guard let bucketItem = bucketItem else {return}

        bucketItemTitleField.text = bucketItem.title
        bucketItemTimestampLabel.text = (" Bucketed: " + bucketItem.timestamp!.formatToString())
        isCompleted = bucketItem.completed
        updateCompletedBtn()
    } // End of Update View
    
    func updateCompletedBtn() {
        if isCompleted == false {
            completedBtn.setImage(UIImage(systemName: "xmark.seal"), for: .normal)
        } else {
            completedBtn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        }
    } // End of Update completed Button
    
    func toggleCompletion(item: BucketItem) {
        if item.completed == true {
            item.completed = false
            BucketFirebaseFunctions.updateBucketItem(bucketItem: item)
            print("Bucket updated")
        } else {
            item.completed = true
            BucketFirebaseFunctions.updateBucketItem(bucketItem: item)
            print("Bucket updated")
        }
    }
    
    func toggleButton() {
        if completedBtn.imageView?.image == UIImage(systemName: "xmark.seal") {
            completedBtn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        } else {
            completedBtn.setImage(UIImage(systemName: "xmark.seal"), for: .normal)
        }
    }
    
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentView.endEditing(true)
        updateView()
    } // End of Function
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editTextDoneBtn()
        self.contentView.endEditing(true)
        return true
    } // End of Func
    
    func editTextDoneBtn() {
        guard let item = bucketItem else { return }
        item.title = bucketItemTitleField.text ?? ""
        BucketFirebaseFunctions.updateBucketItem(bucketItem: item)
        print("Bucket updated")
    } // End of Func
    
    
    // MARK: - Actions
    @IBAction func completedBtn(_ sender: Any) {
        guard let item = self.bucketItem else {return}
        toggleButton()
        toggleCompletion(item: item)
    } // End of Completed Btn

    
} // End of Class Bucket Item Table View Cell
