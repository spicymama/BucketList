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
    @IBOutlet weak var bucketImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var bucketItemsLabel: UITextField!
    
    
    // MARK: - Properties
    var user: User?

    var bucket: Bucket? {
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
        guard let bucket = bucket else {return}

        bucketImageView.isHidden = true
        
        if bucket.note != "" {
            noteLabel.text = bucket.note
        } else {
            noteLabel.isHidden = true
        }
                
        titleLabel.text = bucket.title
        timestampLabel.text = bucket.timestamp?.formatToString()
        
//        beautifyCell()
    } // End of Update Views
    
    
    /* Old update View
     func updateView() {
             guard let post = post else {return}

             noteLabel.text = post.note

             // Image
             if post.imageURL == "" || post.imageURL == nil {
                 postImageView.isHidden = true
             } else {
                 postImageView.image = cachePostImage(post: post)
             }
             
             if post.bucketTitle == "" || post.bucketTitle == nil {
                 titleLabel.isHidden = true
             } else {
                 titleLabel.isHidden = false
                 titleLabel.text = "From Bucket: " + post.bucketTitle!
             }
         
             timestampLabel.text = post.timestamp?.formatToString()
             
             beautifyCell()
         } // End of Update Views
     */


    // MARK: - Image loading
    // This will all eventually be updated to bucket image, because buckets hold posts
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
        self.layer.frame = layer.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    } // End of Function
} // End of Extension
