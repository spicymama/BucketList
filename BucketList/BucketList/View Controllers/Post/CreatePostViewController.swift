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
    @IBOutlet weak var bucketItBtn: UIButton!
    
    
    // MARK: - Properties
    let noteTextViewPlaceholder: String = "Notes, Thoughts, Questions?"
    var bucketID = "0"
    var bucketTitle = ""
    //TODO(ethan) V2.0 - You can post to individual Bucket Items
    
    
    // MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        BucketItTableViewController.delegate = self
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if noteTextView.text.isEmpty {
            updateEmptyNoteText()
        }
        self.view.endEditing(true)
    } // End of Function
    
    
    // MARK: - Actions
    @IBAction func postButtonTapped(_ sender: Any) {
        // Properties
        //TODO(ethan) V2.0 - Let users make posts off of the already existing buckets page - Not just the "create post" page
        let note = noteTextView.text ?? "Post Note"
        let bucketID: String = bucketID
        
        //TODO(ethan) Some function that also creates a saved file of an image, and gets us the ID
        //let imageID = ""
        
        FirebaseFunctions.createPost(note: note, imageID: "lift", bucketID: bucketID)
        
        // Go to the Post's page, in front of the Feed page
        let storyBoard: UIStoryboard = UIStoryboard(name: "gavin", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FeedTableVC")
        // TODO(ethan) -- Might need to go through the whole app and make sure every view pops off
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    } // End of Save button
    
    
    // MARK: - Functions
    func updateView() {
        updateEmptyNoteText()
        updateBucketItBtn(bucketTitle: bucketTitle)
    } // End of Function Update View
    
    // Update Note Functions (Mostly placeholder text stuff)
    func updateEmptyNoteText() {
        noteTextView.text = noteTextViewPlaceholder
        noteTextView.textColor = UIColor.lightGray
    } // End of Func
    
    func textViewDidBeginEditing(_ noteTextView: UITextView) {
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = nil
            noteTextView.textColor = UIColor.black
        }
    } // End of Func
    
    
    
    func updateBucketItBtn(bucketTitle: String) {
        let bucketItBtnTitle = ("Bucket It! " + bucketTitle)
        self.bucketItBtn.setTitle(bucketItBtnTitle, for: .normal)
    }
    
} // End of Class Create Post VC


// MARK: - Extensions
extension CreatePostViewController: BucketItDelegate {
    
    func BucketItPicked(bucketTitle: String, bucketID: String) {
        self.bucketID = bucketID
        self.bucketTitle = bucketTitle
        
        self.updateBucketItBtn(bucketTitle: bucketTitle)
    }
} // End of Extension
