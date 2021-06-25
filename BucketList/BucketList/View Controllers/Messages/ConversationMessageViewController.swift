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
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissInputView))
//        self.view.addGestureRecognizer(tapGesture)
        fetchMessages()
    }
    
    //MARK: - Properties
    
    var conversation: Conversation?
    var messages: [Message] = []
    
    //MARK: - Message Data Functions
    func currentSender() -> SenderType {
//        let user = UserController.shared.currentUser
        guard let user = ConversationController.shared.currentUser else {return Sender(senderId: "not found", displayName: "not found")}
        return Sender(senderId: user.uid, displayName: user.firstName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
//    @objc func dismissInputView() {
//        inputView?.resignFirstResponder()
//    }
    
    func fetchMessages() {
        guard let conversation = conversation else {return}
        ConversationController.shared.fetchMessages(conversation: conversation) { result in
            switch result {
            case true:
                let sortedMessages = ConversationController.shared.messages.sorted { message0, message1 in
                    return message0.sentDate < message1.sentDate
                }
                self.messages = sortedMessages
                self.updateViews()
            case false:
                print("Error in \(#function)")
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }
    }
    
}//End of Class

extension ConversationMessagesViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let conversation = conversation else {return}
//              let user = UserController.shared.currentUser
        guard let user = ConversationController.shared.currentUser else {return}
        ConversationController.shared.saveMessage(sentDate: Date(), senderId: user.uid, displayName: user.firstName, conversationID: conversation.conversationID, text: text)
        inputBar.inputTextView.text = ""
//        inputBar.inputTextView.resignFirstResponder()
//        self.updateViews()
//        ConversationController.shared.fetchMessages(conversation: conversation) { result in
//            switch result {
//            case true:
//                DispatchQueue.main.async {
//                    self.messages = ConversationController.shared.messages
//                }
//            case false:
//                print("Error in \(#function)\(#line)")
//            }
//        }
    }
    
}
