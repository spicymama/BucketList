//
//  ConversationController.swift
//  BucketList
//
//  Created by Justin Webster on 6/21/21.
//

import Foundation
import FirebaseFirestore
import Firebase
import MessageKit

class ConversationController {
    
    //MARK: - Properties
    
    static var shared = ConversationController()
    var conversations: [Conversation] = []
    let db = Firestore.firestore()
    var messages: [Message] = []
    var users: [User] = []
    var currentUser: User?
    
    //MARK: - Functions
    
    func createAndSaveConversation(users: [User], completion: @escaping (Conversation) -> Void) {
        let conversationToAdd = Conversation(userIDs: users)
//        let conversationRef = db.collection("conversations").document(conversationToAdd.conversationID)
//        conversationRef.setData([ "conversationID" : conversationToAdd.conversationID
//                                ])
        db.collection("conversations").document(conversationToAdd.conversationID).setData(["conversationID" : conversationToAdd.conversationID])
        for user in users {
            let userIDsRef = db.collection("conversations").document(conversationToAdd.conversationID).collection("userIDs").document(user.uid)
            userIDsRef.setData(["userID" : user.uid])
            
            completion(conversationToAdd)
        }
    }
    
    func deleteConversation(conversation: Conversation) {
        //JCW -- delete from firebase functionalitiy?
    }
    
    func fetchConversationsFor(_ user: User, completion: @escaping (Bool) -> Void ) {
        db.collection("conversations").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error in \(#function) \(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(false)
            }
            
            if let snapshot = snapshot {
                self.conversations = []
                for doc in snapshot.documents {
                    if user.conversationsIDs.contains(doc.documentID) {
                        print("\(doc.documentID)")
                        let conversationID = doc.documentID
                            
                                let conversation = Conversation(conversationID: conversationID)
                                self.conversations.append(conversation)
                        
                    }
                }
                return completion(true)
            }
        }
    }
    
    func updateConversation(conversation: Conversation, completion: @escaping (Conversation) -> Void) {
       //JCW -- Don't think i need this
    }
    
    
    func saveMessage(messageID: String = UUID().uuidString, sentDate: Date, senderId: String, displayName: String, conversationID: String, text: String) {
        let message = Message(sender: Sender(senderId: senderId, displayName: displayName), messageId: messageID, sentDate: sentDate, kind: .text(text))
        let messageRef = db.collection("conversations").document(conversationID).collection("messages").document(messageID)
        messageRef.setData(["messageID" : message.messageId,
                            "sentDate" : ISO8601DateFormatter().string(from: message.sentDate),
                            "text" : text,
                            "displayName" : displayName,
                            "senderID" : senderId
                            ])
    }
    
    func fetchMessages(conversation: Conversation, completion: @escaping (Bool) -> Void) {
        db.collection("conversations").document(conversation.conversationID).collection("messages").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            if let snapshot = snapshot {
                self.messages = []
                for doc in snapshot.documents {
                        let messageData = doc.data()
                        guard let messageID = messageData["messageID"] as? String,
                              let sentDate = messageData["sentDate"] as? String,
                              let text = messageData["text"] as? String,
                              let displayName = messageData["displayName"] as? String,
                              let senderID = messageData["senderID"] as? String,
                              let formattedDate = ISO8601DateFormatter().date(from: sentDate) else {return print("this got messed up")}
                    
                    let message = Message(sender: Sender(senderId: senderID, displayName: displayName), messageId: messageID, sentDate: formattedDate, kind: .text(text))
                        self.messages.append(message)
                }
                return completion(true)
            }
        }
    }
    
    func fetchUserIDs(for conversationID: String, completion: @escaping ([String]) -> Void) {
        var conversationUserIDs: [String] = []
        db.collection("conversations").document(conversationID).collection("userIDs").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                    let userIDs = doc.data()
                    guard let userID = userIDs["userID"] as? String else {return}
                    
                    if userID == ConversationController.shared.currentUser!.uid {
                        //do nothing
                    } else {
                        conversationUserIDs.append(userID)
                    }
                }
                return completion (conversationUserIDs)
            }
        }
    }
    
    func addUsers(conversation: Conversation, user: User, completion: @escaping (Bool) -> Void) {
        db.collection("conversations").document(conversation.conversationID).collection("userIDs").document(user.uid).setData(["userID" : user.uid])
    }
    
    func updateUsers(users: [User], conversation: Conversation, completion: @escaping (Bool) -> Void) {
        for user in users {
            db.collection("users").document(user.uid).updateData(["conversationsID" : FieldValue.arrayUnion([conversation.conversationID])])
        }
        completion(true)
    }
    
    func getAvatarFor(_ sender: SenderType) -> Avatar {
        
        //fetch users profile image
        
        return Avatar(image: UIImage(systemName: "heart"), initials: "HR")
    }
    
    func fetchMostRecentMessage(for conversation: Conversation, completion: @escaping (String) -> Void) {
        var mostRecentMessage: Message = Message(sender: Sender(senderId: "", displayName: ""), messageId: "", sentDate: Date.distantPast, kind: .text(""))
        var mostRecentMessageText: String = ""
        db.collection("conversations").document(conversation.conversationID).collection("messages").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            if let snapshot = snapshot {
                for doc in snapshot.documents {
                        let messageData = doc.data()
                        guard let messageID = messageData["messageID"] as? String,
                              let sentDate = messageData["sentDate"] as? String,
                              let text = messageData["text"] as? String,
                              let displayName = messageData["displayName"] as? String,
                              let senderID = messageData["senderID"] as? String,
                              let formattedDate = ISO8601DateFormatter().date(from: sentDate) else {return print("this got messed up")}
                    
                    let message = Message(sender: Sender(senderId: senderID, displayName: displayName), messageId: messageID, sentDate: formattedDate, kind: .text(text))
                    if message.sentDate > mostRecentMessage.sentDate {
                        mostRecentMessage = message
                        mostRecentMessageText = text
                    }
                }
                return completion(mostRecentMessageText)
            }
        }
    }
    
    
}//End of Class
