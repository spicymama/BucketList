//
//  EditPostViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/2/21.
//

import UIKit

class EditPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var bucketItBtn: UIButton!
    @IBOutlet weak var postPicImageView: UIImageView!
    @IBOutlet weak var postPicButton: UIButton!
    
    
    // MARK: - Properties
    var noteText: String = ""
    static var postID: String?
    var post: Post?
    var bucketID: String?
    var bucketTitle: String?
    var oldBucketID: String?
    var selectedImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        BucketItTableViewController.delegate = self
        fetchPost()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if noteTextView.text.isEmpty {
            updateNoteText()
        }
        self.view.endEditing(true)
    }
    
    // MARK: - Functions
    func fetchPost() {
        guard let postID = EditPostViewController.postID else { return }
        FirebaseFunctions.fetchPost(postID: postID) { post in
            let fetchedPost: Post = post
            
            self.noteText = fetchedPost.note!
            self.bucketID = fetchedPost.bucketID
            self.oldBucketID = fetchedPost.bucketID
            self.bucketTitle = fetchedPost.bucketTitle
            
            self.updateNoteText()
            self.updateBucketItBtn(bucketTitle: fetchedPost.bucketTitle ?? "")
        }
        
    } // End of Function fetch Post
    
    // Update Note Functions (Mostly placeholder text stuff)
    func updateNoteText() {
        if noteText == "" {
            noteTextView.text = "Notes, Thoughts, Questions?"
            noteTextView.textColor = UIColor.lightGray
        } else {
            noteTextView.text = noteText
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        selectedImage = image
        self.postPicImageView.image = image
        self.postPicButton.setImage(UIImage(), for: .normal)
    } // End of Image picker Function
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    } // End of Function
    
    // MARK: - Actions
    @IBAction func PostPicButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    @IBAction func bucketItBtn(_ sender: Any) {
        oldBucketID = bucketID
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "bucketItTableVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func postBtn(_ sender: Any) {
        // Properties
        //TODO(ethan) V2.0 - Let users make posts off of the already existing buckets page - Not just the "create post" page
        let postID = EditPostViewController.postID
        let note = noteTextView.text ?? "Post Note"
        let imageID = "lift"
        let bucketID: String = bucketID ?? ""
        let oldBucketID: String = oldBucketID ?? ""
        let bucketTitle: String = bucketTitle ?? ""
        
        //TODO(ethan) Some function that also creates a saved file of an image, and gets us the ID
        //let imageID = ""
        
        FirebaseFunctions.editPost(postID: postID, note: note, imageID: imageID, bucketID: bucketID, oldBucketID: oldBucketID, bucketTitle: bucketTitle)
        
        // Go to the Post's page, in front of the Feed page
//        let storyBoard: UIStoryboard = UIStoryboard(name: "gavin", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "FeedTableVC")
        // TODO(ethan) -- Might need to go through the whole app and make sure every view pops off
        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
    } // End of Save button
    
} // End of Class


// MARK: - Extension
extension EditPostViewController: BucketItDelegate {
    func BucketItPicked(bucketTitle: String, bucketID: String) {
        self.bucketTitle = bucketTitle
        self.bucketID = bucketID
        
        self.updateBucketItBtn(bucketTitle: bucketTitle)
    }
} // End of Extension
