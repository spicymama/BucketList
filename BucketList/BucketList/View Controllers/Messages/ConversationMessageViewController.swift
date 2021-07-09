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
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissInputView))
//        self.view.addGestureRecognizer(tapGesture)
        fetchMessages()
    }
    
    //MARK: - Properties
    
    var conversation: Conversation?
    var messages: [Message] = []
    var users: [User]?
    
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
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let avatar = getAvatar(for: message.sender) else {return}
        avatarView.set(avatar: avatar)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.systemBlue.cgColor
        avatarView.backgroundColor = UIColor.systemBackground
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
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].sender.senderId == messages[indexPath.section + 1].sender.senderId
    }
    
    func getAvatar(for sender: SenderType) -> Avatar? {
        var profileImage: UIImage?
        var initials: String = ""
        guard let users = users else {return Avatar(image: UIImage(named: "defaultProfileImage"), initials: "def")}
        for user in users {
            if sender.senderId == user.uid {
                profileImage = cacheImage(user: user)
                initials = "\(user.firstName.first ?? "a")\(user.lastName.first ?? "a")"
            }
        }
        return Avatar(image: profileImage, initials: initials)
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

extension ConversationMessagesViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let user = ConversationController.shared.currentUser else {return}
        if let conversation = conversation {
            ConversationController.shared.saveMessage(sentDate: Date(), senderId: user.uid, displayName: user.firstName, conversationID: conversation.conversationID, text: text)
            inputBar.inputTextView.text = ""
        }
//              let user = UserController.shared.currentUser
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
