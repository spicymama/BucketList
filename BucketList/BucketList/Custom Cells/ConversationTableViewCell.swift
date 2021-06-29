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
            updateViews(for: conversation)
        }
    }
    
    var mostRecentMessage: Message?
    
    //MARK: - Functions
    
    func updateViews(for conversation: Conversation) {
        var usernameString = ""
        for username in conversation.users.compactMap({$0.username}) {
            usernameString.append(usernameString + ", \(username)")
        }
        if conversation.users.count < 3 {
            //use the other users image for the pic
        }
        if conversation.users.count >= 3 {
            // use the defautl image for group messages
        }
    }
    
    func fetchMostRecentMessage(for conversation: Conversation) {
        
    }
    
    
}//End of Class
