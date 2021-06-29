//
//  CreatePostViewController.swift
//  BucketList
//
//  File Created by Gavin Woffinden on 6/22/21.
//  Heavily Forged in Digital Fire by Ethan Andersen on 6/25/21
//

import UIKit

// This whole thing should be presented Modally
class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var noteTextView: UITextView!

    
    // MARK: - Properties
    let noteTextViewPlaceholder: String = "Notes, Thoughts, Questions?"
    var bucketID = "0"
    var bucketItemID = "0"
    
    
    // MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    // MARK: - Functions
    func updateView() {
        updateNoteText()
    } // End of Function Update View
    
    
    // MARK: - Actions
    @IBAction func postButtonTapped(_ sender: Any) {
        // Properties
        //TODO(ethan) V2.0 - Let users make posts off of the already existing buckets page - Not just the "create post" page
        let note = noteTextView.text ?? "Post Note"
        let bucketID: String = bucketID
        let bucketItemID: String = bucketItemID
        
        //TODO(ethan) Some function that also creates a saved file of an image, and gets us the ID
        //let imageID = ""
        
        FirebaseFunctions.createPost(note: note, imageID: "lift", bucketID: bucketID, bucketItemID: bucketItemID)
        
        // Go to the Post's page, in front of the Feed page
        let storyBoard: UIStoryboard = UIStoryboard(name: "gavinPost", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "postVC")
        // TODO(ethan) -- Might need to go through the whole app and make sure every view pops off
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    } // End of Save button
    
    
    // MARK: - Actions
    @IBAction func bucketItBtn(_ sender: Any) {
        //TODO(ethan) Make this pull up a view of the avaliable Bucket lists
        // Delegate protocol here or something
        //TODO(ethan) When they select a Bucket item, it should change to Bucket It: (Name of Bucket)
        //TODO(ethan) When a bucket is selected, a new button should appear that says Item It?
    } // End of Bucket It Button
    
    
    // MARK: - Functions
    // Update Note Functions (Mostly placeholder text stuff)
    func updateNoteText() {
        noteTextView.text = noteTextViewPlaceholder
        noteTextView.textColor = UIColor.lightGray
    } // End of Func
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = nil
            noteTextView.textColor = UIColor.black
        }
    } // End of Func
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTextView.text.isEmpty {
            noteTextView.text = noteTextViewPlaceholder
        }
    } // End of Func
    
    
} // End of Class Create Post VC
