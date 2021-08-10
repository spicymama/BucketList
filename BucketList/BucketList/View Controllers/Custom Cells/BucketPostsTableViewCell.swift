//
//  BucketPostsTableViewCell.swift
//  BucketList
//
//  Created by Ethan Andersen on 8/10/21.
//

import UIKit

class BucketPostsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    
    // MARK: - Properties
    var user: User?
    var post: Post? {
        didSet {
            FirebaseFunctions.fetchUserData(uid: post!.authorID!) { fetchedUser in
                DispatchQueue.main.async {
                    self.user = fetchedUser
                    self.updateViews()
                }
            }
        }
    } // End of Post Variable
    
    
    // MARK: - Lffecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        guard let post = post,
               let user = user else {return}
        
        if post.imageURL == "" {
            postImageView.isHidden = true
        } else {
            cachePostImage(post: post)
        }
        
        if post.bucketTitle == "" {
            postTitle.isHidden = true
        } else {
            postTitle.text = post.bucketTitle
        }
        
        noteLabel.text = post.note
    } // End of Update Views
    
    func cachePostImage(post: Post){
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
                                
                                // Reload the cell
                                
                            }
                        }
                    }
                }
                task.resume()
            }
        }
        postImageView.image = picture
    } // End of Cache post
    
} // End of Class
