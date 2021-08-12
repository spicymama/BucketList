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
    
    
    // MARK: - Properties
    var goalList: [String] = []
    var isPublic: Bool?
    
    static var bucket: Bucket?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noVisibilityOption()
        updateView()
    } // End of View did load
    
    
    // MARK: - Functions
    func noVisibilityOption() {
        visibilitySwitch.isHidden = true
        visibilitySwitch.isEnabled = false
    } // End of Function
    
    func updateView() {
        let bucket = BucketDetailViewController.bucket
        if bucket != nil {
            createNewBucketLabel.text = bucket?.title
            self.isPublic = bucket!.isPublic
            bucketTitleField.text = bucket!.title
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
    } // End of Func
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bucketTitleField.text?.isEmpty == true {
            bucketTitleField.text = "What would you like to do?"
            bucketTitleField.textColor = UIColor.lightGray
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
            let isPublic = isPublic ?? true
            
            let newBucket = Bucket(title: title, isPublic: isPublic)
            
            BucketFirebaseFunctions.createBucket(newBucket: newBucket)
        } else {
            // Update bucket
            guard let title = bucketTitleField.text else { return }
            let isPublic = isPublic ?? true
            
            let bucketToUpdate = Bucket(title: title, isPublic: isPublic)
            
            BucketFirebaseFunctions.updateBucket(bucketToUpdate: bucketToUpdate)
        }
        self.navigationController?.popViewController(animated: true)
    } // End of Save Button
    

} // End of Class Create Bucket
