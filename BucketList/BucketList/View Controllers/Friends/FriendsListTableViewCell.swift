//
//  FriendsListTableViewCell.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/25/21.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    //MARK: - Landing Pad
    var user: User? {
        didSet {
            updateViews()
        }
    } // End of user
    
    
    // MARK: - Functions
    func updateViews() {
        guard let user = user else {return}
        usernameLabel.text = ("~" + user.username)
        cacheImage(user: user)
    }
    
    func cacheImage(user: User) {
        var picture = UIImage()
        let cache = ImageCacheController.shared.cache
        let cacheKey = NSString(string: user.profilePicUrl ?? "")
        
        if user.profilePicUrl == "" || user.profilePicUrl == "defaultProfileImage" {
            picture = UIImage(named: "defaultProfileImage") ?? UIImage()
        } else {
            if let image = cache.object(forKey: cacheKey) {
                picture = image
                profileImage.image = picture
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
        profileImage.image = picture
    } // End of Cache Image
    
} // End of Class
