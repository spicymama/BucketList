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
    var currentUser: User?
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
        EditPostViewController.postID = PostViewController.currentPost?.postID
        
        // Move over to the right VC
        let storyBoard: UIStoryboard = UIStoryboard(name: "EditPost", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "editPostVC")
        self.navigationController?.pushViewController(vs, animated: true)
    } // End of Edit post button
    
    @IBAction func profileDetailBtn(_ sender: Any) {
        guard let currentUser = currentUser else {return}
        if currentUser.uid == PostViewController.currentPost?.authorID {
        ProfileTableViewCell.user = currentUser
        ProfileTableViewController.shared.currentUser = self.currentUser
        ProfileCollectionViewCell.currentUser = currentUser
            let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC")
            navigationController?.pushViewController(vc, animated: true)
        } else {
            FirebaseFunctions.fetchUserData(uid: PostViewController.currentPost?.authorID ?? "") { result in
                ProfileTableViewCell.user = result
                ProfileTableViewController.shared.currentUser = result
                ProfileCollectionViewCell.currentUser = result
            let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
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
            self.currentUser = result
            
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
        let vs = storyBoard.instantiateViewController(withIdentifier: "conversationListVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    func newPostBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "newPostVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    func newBucketBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewBucket", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "BucketListTableVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    func myProfileBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "profileDetailVC")
        guard let currentUser = currentUser else {return}
        ProfileTableViewCell.user = currentUser
        ProfileTableViewController.shared.currentUser = self.currentUser
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    
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
/*
 
 // MARK: - Extensions
 extension PostDetailTableViewController: UITableViewDelegate, UITableViewDataSource {
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return PostViewController.comments.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
 // let commentsID = PostViewController.currentPost?.commentsID
 // cell.commentsID = commentsID
 cell.textLabel?.text = PostViewController.comments[indexPath.row]
 
 return cell
 }
 
 } // End of Extension
 
 */
