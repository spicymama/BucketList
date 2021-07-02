//
//  FeedTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let shared = FeedTableViewCell()
    var username: String = ""
    
    // MARK: - Outlets
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    
    // MARK: - Properties
    var user: User?
    var post: Post? {
        didSet {
            FirebaseFunctions.fetchUserData(uid: post!.authorID) { fetchedUser in
                self.user = fetchedUser
                self.updateViews()
            }
        }
    }
    
    // MARK: - LIfecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        guard let post = post else {return}
        
        profilePic.image = UIImage(named: "peace")
        usernameLabel.text = ((user?.username ?? "User") + " checked " + (post.bucketTitle ?? "something") + "off their list!")
        postImageView.image = UIImage(named: "lift")
        noteLabel.text = post.note
        postTitle.text = post.bucketTitle
    }
    
    
    /*
     func fetchUsername() {
     
     guard let post = post else {return}
     let group = DispatchGroup()
     FirebaseFunctions.fetchUserData(uid: post.creatorID) { result in
     group.enter()
     self.username = result.username
     group.leave()
     group.notify(queue: DispatchQueue.main) {
     self.updateViews()
     
     }
     }
     }
     */
}
