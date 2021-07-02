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
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetchCurrentPost()
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
    
    @IBAction func profileDetailBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
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
 */
    func fetchCurrentUser() {
        guard let post = PostViewController.currentPost else {return}
        FirebaseFunctions.fetchUserData(uid: post.creatorID) { result in
            self.username = result.username
            self.profilePic = result.profilePicture
            print(self.username)
            self.updateViews()
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
        self.usernameLabel.text = self.username
        self.titleLabel.text = PostViewController.currentPost?.title
        self.postImageView.image = UIImage(named: PostViewController.currentPost?.photoID ?? "peace" )
        self.profilePicImageView.image = UIImage(named: "justin")
        self.postDescription.text = PostViewController.currentPost?.description
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
