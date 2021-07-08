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
            FirebaseFunctions.fetchUserData(uid: post!.authorID) { fetchedUser in
                DispatchQueue.main.async {
                self.user = fetchedUser
                self.updateViews()
                }
            }
        }
    }
    
    // MARK: - LIfecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        guard let post = post,
               let user = user else {return}
        usernameLabel.text = ("~" + (user.username) + " checked " + (post.bucketTitle ?? "something") + " off their list!")
        postImageView.image = cachePostImage(post: post)
        noteLabel.text = post.note
        postTitle.text = post.bucketTitle
        profilePic.image = cacheImage(user: user)
    }
   
    
    func randomPhoto() -> String {
        let randomNumber = Int.random(in: 0...9)
        
        return String(randomNumber)
    }
    
    func cacheImage(user: User)-> UIImage {
        var picture = UIImage()
        let cache = ImageCacheController.shared.cache
        let cacheKey = NSString(string: user.profilePicUrl ?? "")
        if let image = cache.object(forKey: cacheKey) {
            picture = image
        } else {
            if user.profilePicUrl == "" {
                picture = UIImage(named: "defaultProfileImage") ?? UIImage()
            }
            
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
        return picture
    }
    
    func cachePostImage(post: Post) -> UIImage {
        var picture = UIImage()
        let cache = ImageCacheController.shared.cache
        let cacheKey = NSString(string: post.photoID )
        if let image = cache.object(forKey: cacheKey) {
            picture = image
        } else {
            
            let session = URLSession.shared
            
            if post.photoID != "" {
                let url = URL(string: post.photoID)!
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
    }
    
    
} // End of Feed Table View Cell

/*
func fetchProfilePic(pictureURL: String, completion: @escaping (UIImage) -> Void){
    guard let url = URL(string: pictureURL) else {return}
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: { 📀, _, 🛑 in
        guard let 📀 = 📀, 🛑 == nil else {
            print("Error in \(#function)\(#line)")
            return
        }
        DispatchQueue.main.async {
            guard let image = UIImage(data: 📀) else {return}
           //self.profilePic.image = image
           completion(image)
        } // End of Dispatch Queue
    })
    task.resume()
}
*/
