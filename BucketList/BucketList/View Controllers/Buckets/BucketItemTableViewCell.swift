//
//  BucketItemTableViewCell.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/8/21.
//

import UIKit

class BucketItemTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var bucketItemTitleField: UITextField!
    @IBOutlet weak var bucketItemNoteField: UITextField!
    @IBOutlet weak var bucketItemTimestampLabel: UILabel!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var isCompleted: Bool?
    
    // MARK: - Properties
    var bucketItem: BucketItem? {
        didSet {
            updateView()
        }
    } // End of Var Bucket Item
    
    
    // MARK: - Functions
    func updateView() {
        saveBtn.isHidden = true
        bucketItemTitleField.text = bucketItem?.title
        bucketItemNoteField.text = bucketItem?.note
        bucketItemTimestampLabel.text = bucketItem?.timestamp?.formatToString()
        isCompleted = bucketItem!.completed
        updateCompletedBtn()
    } // End of Update View
    
    
    func updateCompletedBtn() {
        if isCompleted == false {
            completedBtn.setImage(UIImage(systemName: "xmark.seal"), for: .normal)
        } else {
            completedBtn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        }
    } // End of Update completed Button
    
    
    // MARK: - Actions
    @IBAction func completedBtn(_ sender: Any) {
        isCompleted?.toggle()
        updateCompletedBtn()
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
    }
} // End of Extension
