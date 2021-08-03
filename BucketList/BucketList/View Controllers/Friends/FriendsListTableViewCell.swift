//
//  FriendsListTableViewCell.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/25/21.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
//MARK: - Outlets
    
   
    @IBOutlet weak var nameLabel: UILabel!
    
  
    @IBOutlet weak var usernameLabel: UILabel!
    
   
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK: -Properties
    
    
    
    //MARK: - Landing Pad
    var user: User? {
        didSet {
        updateViews()
    }
}
    
    
    
    func updateViews() {
        guard let user = user else {return}
        nameLabel.text = (user.firstName + " " + user.lastName)
        usernameLabel.text = ("~" + user.username)
        profileImage.image = cacheImage(user: user)
        
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
    
}//end of class
