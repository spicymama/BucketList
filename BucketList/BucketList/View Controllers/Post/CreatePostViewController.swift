//
//  CreatePostViewController.swift
//  BucketList
//
//  File Created by Gavin Woffinden on 6/22/21.
//  Heavily Forged in Digital Fire by Ethan Andersen on 6/25/21
//

import UIKit
import Firebase
import FirebaseStorage

// This whole thing should be presented Modally
class CreatePostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var bucketItBtn: UIButton!
    @IBOutlet weak var postPictureButton: UIButton!
    @IBOutlet weak var selectedImageImageView: UIImageView!
    
    
    // MARK: - Properties
    let noteTextViewPlaceholder: String = "Notes, Thoughts, Questions?"
    var bucketID = "0"
    var bucketTitle = ""
    var selectedImage: UIImage?
    //TODO(ethan) V2.0 - You can post to individual Bucket Items
    
    
    // MARK: - Lifeycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        BucketItTableViewController.delegate = self
        updateView()
    }
    
    @IBAction func postPictureButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        selectedImage = image
        self.selectedImageImageView.image = image
        self.postPictureButton.setImage(UIImage(), for: .normal)
    } // End of Image picker Function
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    } // End of Function
    
    // MARK: - Actions
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let image = selectedImage else {return}
        // Properties
        //TODO(ethan) V2.0 - Let users make posts off of the already existing buckets page - Not just the "create post" page
        let note = noteTextView.text ?? "Post Note"
        let bucketID: String = bucketID
            
        FirebaseFunctions.createPost(note: note, bucketID: bucketID, bucketTitle: bucketTitle, image: image)
        
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
