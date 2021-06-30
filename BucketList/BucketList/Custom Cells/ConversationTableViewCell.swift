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
    
    //MARK: - Functions
    
    func updateViews(for conversation: Conversation) {
        guard let currentUser = ConversationController.shared.currentUser else {return}
        var usernameString = ""
        for user in conversation.users {
            if user.uid == currentUser.uid {
                //do nothing
            } else {
                if usernameString == "" {
                    usernameString = usernameString + user.firstName
                } else {
                    usernameString = usernameString + ", \(user.firstName)"
                }
            }
        }
        //        if conversation.users.count < 3 {
        //            userAvatarImageView.image = UIImage(systemName: "heart")
        //        }
        //        if conversation.users.count >= 3 {
        //            userAvatarImageView.image = UIImage(systemName: "heart.fill")
        //        }
        usernameLabel.text = usernameString
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
    
    
}//End of Class
