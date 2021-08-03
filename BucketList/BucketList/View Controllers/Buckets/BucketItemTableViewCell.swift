//
//  BucketItemTableViewCell.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/8/21.
//

import UIKit

class BucketItemTableViewCell: UITableViewCell {
    static let shared = BucketItemTableViewCell()
    
    // MARK: - Outlets
    @IBOutlet weak var bucketItemTitleField: UITextField!
    @IBOutlet weak var bucketItemNoteField: UITextField!
    @IBOutlet weak var bucketItemTimestampLabel: UILabel!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var isCompleted: Bool?
    var selectedCell: UITableViewCell?
    var bucketItemsArr: [BucketItem] = []
    
    // MARK: - Properties
    var bucketItem: BucketItem? {
        didSet {
            updateView()
        }
    } // End of Var Bucket Item
    
    
    // MARK: - Functions
    func updateView() {
        guard let bucketItem = bucketItem else {return}
        saveBtn.isHidden = true
        bucketItemTitleField.text = bucketItem.title
        bucketItemNoteField.text = bucketItem.note
        bucketItemTimestampLabel.text = (" Bucketed: " + bucketItem.timestamp!.formatToString())
        isCompleted = bucketItem.completed
        //bucketItemsArr.append(bucketItem)
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
        } else {
            item.completed = true
            BucketFirebaseFunctions.updateBucketItem(bucketItem: item)
        }
    }
    func toggleButton() {
        if completedBtn.imageView?.image == UIImage(systemName: "xmark.seal") {
            completedBtn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        } else {
            completedBtn.setImage(UIImage(systemName: "xmark.seal"), for: .normal)
        }
    }
    // MARK: - Actions
    @IBAction func completedBtn(_ sender: Any) {
        guard let item = self.bucketItem else {return}
        toggleCompletion(item: item)
        updateCompletedBtn()
        toggleButton()
    } // End of Completed Btn
    
    @IBAction func saveBtn(_ sender: Any) {
        guard let bucketID = bucketItem?.bucketID else { return }
        guard let title = bucketItemTitleField.text else { return }
        let note = bucketItemNoteField.text ?? ""
        let completed = isCompleted ?? false
        
        let bucketItem = BucketItem(bucketID: bucketID, title: title, note: note, completed: completed)
        
        BucketFirebaseFunctions.updateBucketItem(bucketItem: bucketItem)
        updateCompletedBtn()
        saveBtn.isHidden = true
    } // End of Save Btn
    
} // End of Class Bucket Item Table View Cell


// MARK: - Extensions
extension BucketItemTableViewCell: SaveBtnDelegate {
    func toggleSaveBtn(isVisible: Bool) {
        saveBtn.isHidden = false
        print("Is this thing on?")
    }
} // End of Extension
