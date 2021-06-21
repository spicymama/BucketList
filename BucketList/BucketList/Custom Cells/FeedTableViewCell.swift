//
//  FeedTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var postDetailTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func profileButtonTapped(_ sender: Any) {
    }
    
    var user: User? {
        didSet {
          updateViews()
     
        }
    }

    func updateViews() {
        guard let user = user else {return}
        profilePic.image = user.profilePicture
        usernameLabel.text = "\(user.username) checked something off his list"
        postImageView.image = user.allPictures[0]
        goalLabel.text = user.goals[0]
        postDetailTextView.text = "Details about the thing"
       
    }
}

}
