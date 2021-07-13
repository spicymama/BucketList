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

        noteLabel.text = post.note

        // Image
        if post.imageURL == "" {
            postImageView.isHidden = true
        } else {
            postImageView.image = cachePostImage(post: post)
        }
        
        titleLabel.text = post.bucketTitle
        timestampLabel.text = post.timestamp?.formatToString()
        beautifyCell()
    } // End of Update Views


    // MARK: - Image loading
    // Cache post image
    func cachePostImage(post: Post) -> UIImage {
        var picture = UIImage()
        let cache = ImageCacheController.shared.cache
        let cacheKey = NSString(string: post.imageURL ?? "" )
        if let image = cache.object(forKey: cacheKey) {
            picture = image
        } else {
            
            let session = URLSession.shared
            
            if post.imageURL != "" {
                let url = URL(string: post.imageURL!)!
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error in \(#function): On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                        print("Unable to fetch image for \(post.postID)")
                    }
                    if let data = data {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                picture = image
                                cache.setObject(image, forKey: cacheKey)
                                
                            }
                        }
                    }
                }
                task.resume()
            }
        }
        return picture
    } // End of Cache post
    
} // End of Class Profile Table View Cell


// MARK: - Extensions
extension ProfileTableViewCell {
    func beautifyCell() {
        self.contentView.backgroundColor = .white
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 24.0
        self.layer.frame = layer.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5))
    } // End of Function
} // End of Extension
