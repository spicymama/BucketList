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
    @IBOutlet weak var timestampLabel: UILabel!
    
    
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
        if post.bucketTitle == "" {
            usernameLabel.text = ("~" + (user.username) + " posted")
        } else {
            usernameLabel.text = ("~" + (user.username) + " bucketed: " + (post.bucketTitle!))
        }
        
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
        
        timestampLabel.text = post.timestamp?.formatToString()
        noteLabel.text = post.note
        cacheImage(user: user)
    
    } // End of Update Views

    
    func cacheImage(user: User) {
        var picture = UIImage()
        let cache = ImageCacheController.shared.cache
        let cacheKey = NSString(string: user.profilePicUrl ?? "")
        
        if user.profilePicUrl == "" || user.profilePicUrl == "defaultProfileImage" {
            picture = UIImage(named: "defaultProfileImage") ?? UIImage()
        } else {
            if let image = cache.object(forKey: cacheKey) {
                picture = image
                profilePic.image = picture
            } else {
                let session = URLSession.shared
                
                if user.profilePicUrl != "" {
                    let url = URL(string: user.profilePicUrl ?? "")!
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if let error = error {
                            print("Error in \(#function): On Line \(#line) : \(error.localizedDescription) \n---\n \(error)")
                            print("Unable to fetch image for \(user.username)")
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
        }
        profilePic.image = picture
    } // End of Cache Image
    
    func cachePostImage(post: Post) {
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
    
} // End of Feed Table View Cell
