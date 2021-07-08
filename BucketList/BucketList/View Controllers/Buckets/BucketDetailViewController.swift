//
//  CreateBucketViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/29/21.
//

import UIKit

class BucketDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var createNewBucketLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    @IBOutlet weak var bucketTitleField: UITextField!
    @IBOutlet weak var bucketNoteField: UITextField!
    
    
    // MARK: - Properties
    var goalList: [String] = []
    var isPublic: Bool?
    
    static var bucket: Bucket?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    } // End of View did load
    
    
    // MARK: - Functions
    func updateView() {
        let bucket = BucketDetailViewController.bucket
        if bucket != nil {
            createNewBucketLabel.text = bucket?.title
            self.isPublic = bucket!.isPublic
            bucketTitleField.text = bucket!.title
            bucketNoteField.text = bucket!.note
        } else {
            isPublic = true
        }
        updateVisibilityStatus()
    } // End of Func update View
    
    // This function makes the keyboard go away when typing around
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } // End of Function
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bucketTitleField.textColor == UIColor.lightGray {
            bucketTitleField.text = nil
            bucketTitleField.textColor = UIColor.black
        }
        if bucketNoteField.textColor == UIColor.lightGray {
            bucketNoteField.text = nil
            bucketNoteField.textColor = UIColor.black
        }
    } // End of Func
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bucketTitleField.text?.isEmpty == true {
            bucketTitleField.text = "What would you like to do?"
            bucketTitleField.textColor = UIColor.lightGray
        }
        if bucketNoteField.text?.isEmpty == true {
            bucketNoteField.text = "What would you like to do?"
            bucketNoteField.textColor = UIColor.lightGray
        }
    } // End of Func
    
    func updateVisibilityStatus() {
        if isPublic == true {
            visibilityLabel.text = "Public"
            visibilitySwitch.isOn = true
        } else {
            visibilityLabel.text = "Private"
            visibilitySwitch.isOn = false
        }
    } // End of Update visibility switch
    
    
    // MARK: - Actions
    @IBAction func visibilitySwitch(_ sender: Any) {
        isPublic?.toggle()
        updateVisibilityStatus()
    } // End of Visibility switch toggle

    @IBAction func saveBtn(_ sender: Any) {
        // Check if the bucket exists
        if (BucketDetailViewController.bucket == nil) {
            // Create new Bucket
            guard let title = bucketTitleField.text else { return }
            let note = bucketNoteField.text ?? ""
            let isPublic = isPublic ?? true
            
            let newBucket = Bucket(title: title, note: note, isPublic: isPublic)
            
            BucketFirebaseFunctions.createBucket(newBucket: newBucket)
        } else {
            // Update bucket
            guard let title = bucketTitleField.text else { return }
            let note = bucketNoteField.text ?? ""
            let isPublic = isPublic ?? true
            
            let bucketToUpdate = Bucket(title: title, note: note, isPublic: isPublic)
            
            BucketFirebaseFunctions.updateBucket(bucketToUpdate: bucketToUpdate)
        }
        self.navigationController?.popViewController(animated: true)
    } // End of Save Button
    

} // End of Class Create Bucket
