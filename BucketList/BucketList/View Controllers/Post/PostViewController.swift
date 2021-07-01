//
//  PostViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/25/21.
//

import UIKit

class PostViewController: UIViewController {

    // MARK: - Properties
    var postID: String?
   static var currentPost: Post?
    var currentUser: User?
    var username: String?
    var profilePic: UIImage?
    var timeStamp: Date?
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentPost()
       // fetchCurrentUser()
       // updateViews()
    }

    @IBAction func postCommentButtonTapped(_ sender: Any) {
    }
    
    @IBAction func profileDetailBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchCurrentPost() {
        guard let ID = postID else {return}
        FirebaseFunctions.fetchPost(postID: ID) { data in
                
            let postID: String = data["commentsID"] as! String
            let postDecription: String = data["postNote"] as! String
            let postTitle: String = data["title"] as? String ?? "Title"
            let photoID: String = "swing"
            let creatorID: String = (data["creatorID"] as? String) ?? ""
     
            
            PostViewController.currentPost = Post(commentsID: postID, photoID: photoID, description: postDecription, title: postTitle, creatorID: creatorID)
            self.fetchCurrentUser()
        }
        
        
    }
    func fetchCurrentUser() {
        guard let post = PostViewController.currentPost else {return}
        FirebaseFunctions.fetchUserData(uid: post.creatorID) { result in
            self.username = result.username
            self.profilePic = result.profilePicture
            print(self.username)
            self.updateViews()
        }
    }
    
    func updateViews() {
        self.usernameLabel.text = self.username
        self.titleLabel.text = PostViewController.currentPost?.title
        self.postImageView.image = UIImage(named: PostViewController.currentPost?.photoID ?? "peace" )
        self.profilePicImageView.image = UIImage(named: "justin")
        self.postDescription.text = PostViewController.currentPost?.description
    }
    
    
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
    
    
} // End of Class


// MARK: - Extensions
extension PostDetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? PostCommentsTableViewCell else {return UITableViewCell()}
        let commentsID = PostViewController.currentPost?.commentsID
        cell.commentsID = commentsID
        
        return cell
    }

} // End of Extension


