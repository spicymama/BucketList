//
//  PostViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/25/21.
//

import UIKit
import FirebaseAuth

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let shared = PostViewController()
    
    // MARK: - Outlets
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var lilTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postNote: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Properties
    var postID: String?
    var postComments: [Comment] = []
    static var currentPost: Post?
    var postUser: User?
    var username: String?
    var profilePic: UIImage?
    var timeStamp: Date?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        lilTableView.delegate = self
        lilTableView.dataSource = self
        //fetchCurrentUser()
        fetchData()
    } // End of View did load
    
    
    // MARK: - Actions
    @IBAction func postCommentButtonTapped(_ sender: Any) {
        if (commentTextField.text != "") {
            guard let commentNote = commentTextField.text else {return}
            guard let commentAuthorID = Auth.auth().currentUser?.uid else { return }
            
            FirebaseFunctions.fetchUserData(uid: commentAuthorID) { User in
                let authorUsername = User.username
                let comment = Comment(commentsID: self.postID!, authorUsername: authorUsername, note: commentNote)
                
                FirebaseFunctions.postComment(comment: comment)
                self.postComments.append(comment)
                
                self.commentTextField.text = ""
                self.lilTableView.reloadData()
            }
        }
    } // End of Post Comment Button Tapped
    
    @IBAction func editPostBtn(_ sender: Any) {
        // Send over the post data
        let alert = UIAlertController(title: "Edit Post", message: nil, preferredStyle: .actionSheet)
        EditPostViewController.postID = PostViewController.currentPost?.postID
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelBtn)
        
        let editBtn = UIAlertAction(title: "Edit", style: .default) { _ in
            EditPostViewController.postID = self.postID
            let storyBoard: UIStoryboard = UIStoryboard(name: "EditPost", bundle: nil)
            let vs = storyBoard.instantiateViewController(withIdentifier: "editPostVC")
            self.navigationController?.pushViewController(vs, animated: true)
        }
        alert.addAction(editBtn)
        
        let deleteBtn = UIAlertAction(title: "Delete Post", style: .default) { _ in
            let deleteAlert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            deleteAlert.addAction(cancelBtn)
            
            let confirmDeleteBtn = UIAlertAction(title: "Yes, Delete", style: .default) { _ in
                FirebaseFunctions.deletePost(postID: self.postID!)
                self.navigationController?.popViewController(animated: true)
            }
            confirmDeleteBtn.setValue(UIColor.red, forKey: "titleTextColor")
            deleteAlert.addAction(confirmDeleteBtn)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
        deleteBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(deleteBtn)
        
        present(alert, animated: true, completion: nil)
    } // End of Edit post button
    
    @IBAction func profileDetailBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC")
        // Pass over the user information
        ProfileViewController.profileUser = self.postUser
        navigationController?.pushViewController(vc, animated: true)
    } // End of Profile Detail Button
    
    
    // MARK: - Functions
    func fetchData() {
        fetchCurrentPost()
        fetchCurrentUser()
        fetchPostComments()
        updateViews()
    }
    
    func updateViews() {
        guard let post = PostViewController.currentPost else { return }
        if post.bucketTitle != "" {
            self.titleLabel.text = post.bucketTitle
        } else {
            self.titleLabel.text = ""
        }
        self.usernameLabel.text = self.username
        self.postImageView.image = UIImage(named: PostViewController.currentPost?.photoID ?? "peace" )
        self.profilePicImageView.image = UIImage(named: "justin")
        self.postNote.text = PostViewController.currentPost?.note
    } // End of Function update Views
    
    func fetchCurrentPost() {
        postID = PostViewController.currentPost?.postID
        FirebaseFunctions.fetchPost(postID: postID!) { post in
            let fetchedPost: Post = post
            
            PostViewController.currentPost = fetchedPost
        }
    } // End of Fetch Current Post
    
    func fetchCurrentUser() {
        guard let post = PostViewController.currentPost else {return}
        FirebaseFunctions.fetchUserData(uid: post.authorID) { result in
            self.username = result.username
            //  self.profilePic = result.profilePictureURL
            self.postUser = result
            
            self.updateViews()
        }
    } // End of Fetch current user
    
    func fetchPostComments() {
        postID = PostViewController.currentPost?.postID
        FirebaseFunctions.fetchCommentsData(postID: postID!) { Comments in
            DispatchQueue.main.async {
                self.postComments = Comments
                
                self.updateViews()
                self.lilTableView.reloadData()
            }
        }
    } // End of Fetch Post Comments
    
    
    // MARK: - Menu Button Stuff
    @IBAction func menuBtn(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // The buttons!
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelBtn)
        
        let conversationBtn = UIAlertAction(title: "Messsages", style: .default) { _ in
            self.conversationBtn()
        }
        alert.addAction(conversationBtn)
        
        let newPostBtn = UIAlertAction(title: "Make New Post", style: .default) { _ in
            self.newPostBtn()
        }
        alert.addAction(newPostBtn)
        
        let bucketBtn = UIAlertAction(title: "My Buckets", style: .default) { _ in
            self.newBucketBtn()
        }
        alert.addAction(bucketBtn)
        
        let profileBtn = UIAlertAction(title: "My Profile", style: .default) { _ in
            self.myProfileBtn()
        }
        alert.addAction(profileBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    func conversationBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "conversationListVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func newPostBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "newPostVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func newBucketBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewBucket", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "BucketListTableVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func myProfileBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "profileDetailVC")
        
        FirebaseFunctions.fetchCurrentUserData { fetchedUser in
            ProfileViewController.profileUser = fetchedUser
            self.navigationController?.pushViewController(vc, animated: true)
        }
    } // End of My Profile Button
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        cell.textLabel?.text = self.postComments[indexPath.row].note
        cell.detailTextLabel?.text = self.postComments[indexPath.row].authorUsername
        
        return cell
    }
} // End of Class
