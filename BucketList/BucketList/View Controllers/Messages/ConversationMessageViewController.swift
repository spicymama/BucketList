//
//  ConversationMessagesViewController.swift
//  BucketList
//
//  Created by Justin Webster on 6/21/21.
//
import MessageKit
import Firebase
import UIKit
import InputBarAccessoryView

class ConversationMessagesViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    //MARK: - Outlets
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMessages()
    }
    
    //MARK: - Properties
    
    var conversation: Conversation?
    var messages: [Message] = []
    
    //MARK: - Message Data Functions
    func currentSender() -> SenderType {
        let user = UserController.shared.currentUser
        return Sender(senderId: user.uid, displayName: "TODO: - Fix this")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func fetchMessages() {
        guard let conversation = conversation else {return}
        ConversationController.shared.fetchMessages(conversation: conversation) { result in
            switch result {
            case true:
                self.messages = ConversationController.shared.messages
                self.updateViews()
            case false:
                print("Error in \(#function)")
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            //JCW -- updatestuff here
            self.fetchMessages()
        }
    }
    
}//End of Class

extension ConversationMessagesViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
    }
    
}
