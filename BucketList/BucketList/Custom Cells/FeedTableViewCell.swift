//
//  FeedTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
static let shared = FeedTableViewCell()
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var postDetailTextView: UITextView!
    @IBOutlet weak var profileButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
/*
    @IBAction func profileButtonTapped(_ sender: Any) {
        guard let profileTableViewController = UIStoryboard(name: "gavin", bundle: nil).instantiateViewController(identifier: "profilePage") as? ProfileTableViewController else {return}

        profileTableViewController.userID = post?.creatorID
    }
    */
    var post: Post? {
        didSet {
          updateViews()
     
        }
    }

    func updateViews() {
        guard let post = post else {return}
        
        profilePic.image = UIImage(named: "peace")
        usernameLabel.text = "Gavin checked something off his list"
        postImageView.image = UIImage(named: "lift")
        goalLabel.text = post.title
        postDetailTextView.text = post.description
       
    }

}
