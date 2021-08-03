//
//  ConversationTableViewCell.swift
//  BucketList
//
//  Created by Justin Webster on 6/29/21.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var recentMessageTextView: UITextView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    //MARK: - Properties
    
    var conversation: Conversation? {
        didSet {
            guard let conversation = conversation else {return}
            fetchMostRecentMessage(for: conversation)
            fetchUsers(for: conversation) { users in
                conversation.users = users
                self.updateViews(for: conversation)
            }
        }
    }
    
    var mostRecentMessage: String = ""
    var otherUser: User?
    
    
    //MARK: - Functions
    func updateViews(for conversation: Conversation) {
        guard let currentUser = ConversationController.shared.currentUser else {return}
        var usernameString = ""
        for user in conversation.users {
            if user.uid != currentUser.uid {
                otherUser = user
            }
        } // End of Loop
        
        if conversation.users.count < 3 {
            guard let otherUser = otherUser else {return}
            userAvatarImageView.image = cacheImage(user: otherUser )
        }
        if conversation.users.count >= 3 {
            userAvatarImageView.image = UIImage(systemName: "defaultProfilePhoto")
        }
        usernameLabel.text = ("~" + otherUser!.username)
        recentMessageTextView.text = mostRecentMessage
        userAvatarImageView.layer.masksToBounds = false
        userAvatarImageView.clipsToBounds = true
        userAvatarImageView.layer.borderWidth = 4.0
        userAvatarImageView.layer.borderColor = UIColor.systemBlue.cgColor
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.height / 2
    }
    
    func fetchMostRecentMessage(for conversation: Conversation) {
        ConversationController.shared.fetchMostRecentMessage(for: conversation) { message in
            self.mostRecentMessage = message
        }
    }
    func fetchUsers(for conversation: Conversation, completion: @escaping ([User]) -> Void) {
        ConversationController.shared.fetchUserIDs(for: conversation.conversationID) { userIDs in
            FirebaseFunctions.fetchUsersData(passedUserIDs: userIDs) { users in
                completion(users)
            }
        }
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
    
    
}//End of Class
