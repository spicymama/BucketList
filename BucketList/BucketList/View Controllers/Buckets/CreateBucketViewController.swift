//
//  CreateBucketViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/29/21.
//

import UIKit

class CreateBucketViewController: UIViewController {

    var goalList: [String] = []
    
    @IBOutlet weak var lilTableView: UITableView!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let text = goalTextField.text else {return}
        if !text.isEmpty {
        goalList.append(text)
            goalTextField.text = ""
        }
        guard let title = titleTextField.text else {return}
        if !title.isEmpty {
            BucketFirebaseFunctions.createBucket(title: title, isPublic: true, itemsID: "", note: goalTextField.text ?? "", commentsID: "" )
        self.dismiss(animated: true)
        }
    }
    @IBAction func addToListButtonTapped(_ sender: Any) {
        guard let text = goalTextField.text else {return}
        if !text.isEmpty {
        goalList.append(text)
            goalTextField.text = ""
        }
    }
    
    func updateNoteText() {
        goalTextField.text = "What would you like to do?"
        goalTextField.textColor = UIColor.lightGray
    } // End of Func
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if goalTextField.textColor == UIColor.lightGray {
            goalTextField.text = nil
            goalTextField.textColor = UIColor.black
        }
    } // End of Func
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = goalTextField.text else {return}
        if text.isEmpty {
            goalTextField.text = "What would you like to do?"
        }
    } // End of Func
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
