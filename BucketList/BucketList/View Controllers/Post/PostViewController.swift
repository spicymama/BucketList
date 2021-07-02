//
//  PostViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/25/21.
//

import UIKit

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    // MARK: - Properties
    var commentsID: String?
   static var currentPost: Post?
    static var userID: String?
    var currentUser: User?
    var username: String?
    var profilePic: UIImage?
    var timeStamp: Date?
    static var comments: [String] = []
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
    static var comments: [String] = ["That's cool!", "You are cool!", "Cool thing you have done!", "Very friggin cool!"]
    static var currentPost: Post?
    var currentUser: User?
    var username: String?
    var profilePic: UIImage?
    var timeStamp: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        lilTableView.delegate = self
        lilTableView.dataSource = self
        fetchComments()
        updateViews()
    }

    @IBAction func postCommentButtonTapped(_ sender: Any) {
        if (commentTextField.text != "") {
            guard let comment = commentTextField.text else {return}
            PostViewController.comments.append(comment)
            commentTextField.text = ""
            lilTableView.reloadData()
        }
    }
    
    @IBAction func editPostBtn(_ sender: Any) {
        // Send over the post data
        EditPostViewController.postID = postID
        
        // Move over to the right VC
        let storyBoard: UIStoryboard = UIStoryboard(name: "EditPost", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "editPostVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    @IBAction func profileDetailBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    func fetchCurrentPost() {
        postID = PostViewController.currentPost?.postID
        FirebaseFunctions.fetchPost(postID: postID!) { post in
            let fetchedPost: Post = post
            
            PostViewController.currentPost = fetchedPost
            self.fetchCurrentUser()
        }
    }
 */
    func fetchCurrentUser() {
        guard let id = PostViewController.userID else {return}
        FirebaseFunctions.fetchUserData(uid: id) { result in
            guard let username: String? = result.username else {return}
            self.username = username
            self.profilePic = result.profilePicture
            print(self.username)
            
        }
    }
    func fetchComments() {
        guard let post = PostViewController.currentPost else {return}
        FirebaseFunctions.fetchComments(commentsID: post.commentsID) { result in
            DispatchQueue.main.async {
                self.lilTableView.reloadData()
            }
        }
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
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostViewController.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        cell.textLabel?.text = PostViewController.comments[indexPath.row]
        
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
