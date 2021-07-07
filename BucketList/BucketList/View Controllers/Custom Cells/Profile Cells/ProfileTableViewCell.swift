//
//  ProfileTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit
import Firebase
import FirebaseStorage


class ProfileTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!

    
    
    // MARK: - Properties
    var user: User?
    
    var post: Post? {
        didSet {
            updateView()
        }
    } // End of Post variable
    
    
    // MARK: - LIfecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    } // End of Lifecycle
    
    
    // MARK: - Functions
    func updateView() {
        guard let post = post else {return}
        
        postImageView.image = UIImage(named: "lift")
        noteLabel.text = post.note
        titleLabel.text = post.bucketTitle
        timestampLabel.text = post.timestamp.formatToString()
    } // End of Update Views

    
} // End of Class Profile Table View Cell
