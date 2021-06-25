//
//  CreatePostViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/22/21.
//  Heavily Forged in Digital Fire by Ethan Andersen on 6/25/21
//

import UIKit

class CreatePostViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var postDescriptionTextField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    // MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    // MARK: - Functions
    func updateView() {
        
    } // End of Function Update View
    
    
    // MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
    }
    @IBAction func toDoButtonTapped(_ sender: Any) {
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        FirebaseFunctions.createPost(title: titleTextField.text!, description: postDescriptionTextField.text!, imageID: "lift", progress: false)
        print("Stuff worked")
    }

    
    
} // End of Class
