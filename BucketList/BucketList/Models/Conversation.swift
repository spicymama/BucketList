//
//  Conversation.swift
//  BucketList
//
//  Created by Justin Webster on 6/21/21.
//
import Foundation
import Firebase
import MessageKit

class Conversation {
    
    var conversationID: String
    var users: [User]
    
    init(conversationID: String = UUID().uuidString, userIDs: [User] = []) {
        self.conversationID = conversationID
        self.users = userIDs
    }
}//End of Class

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
