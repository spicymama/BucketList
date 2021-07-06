//
//  ProfileCollectionViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/22/21.
//

import UIKit


class ProfileCollectionViewCell: UICollectionViewCell {
    static var currentUser: User?
    var post: Post?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    var text: String? {
        didSet {
            updateViews()
        }
    }
 
    override func awakeFromNib() {
         super.awakeFromNib()
         
         contentView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             contentView.leftAnchor.constraint(equalTo: leftAnchor),
             contentView.rightAnchor.constraint(equalTo: rightAnchor),
             contentView.topAnchor.constraint(equalTo: topAnchor),
             contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
         ])
     }
    func updateViews() {
        guard let currentUser = ProfileCollectionViewCell.currentUser else {return}
        label.text = text
        print(text)
        self.reloadInputViews()
    
       // imageView.image = post?.photoID
    }
    
        func configure() {
        imageView.image = UIImage(named: "peace")
        label.text = "It worked!"
    }
    
    func fetchUsersPosts(postId: String) {
        FirebaseFunctions.fetchPost(postID: postId) { result in
        self.post = result
        }
    }
}
