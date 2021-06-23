//
//  CreatePostViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/22/21.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var postDescriptionTextField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
    }
    @IBAction func toDoButtonTapped(_ sender: Any) {
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        FirebaseFunctions.createPost(title: titleTextField.text!, description: postDescriptionTextField.text!, imageID: "lift", progress: false)
        print("Shit worked")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
