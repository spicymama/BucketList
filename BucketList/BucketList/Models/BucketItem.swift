//
//  BucketItem.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/28/21.
//

import Foundation

class BucketItem {
    
    var bucketID: String
    var title: String
    var note: String
    
    var itemID: String
    var commentsID: String
    var completed: Bool
    var reactions: [String]
    var timestamp: Date?
    
    init(bucketID: String, title: String, note: String, itemID: String = "", commentsID: String = "", completed: Bool, reactions: [String] = [], timestamp: Date = Date()) {
        self.bucketID = bucketID
        self.title = title
        self.note = note
        self.itemID = itemID
        self.commentsID = itemID
        self.completed = completed
        self.reactions = reactions
        self.timestamp = timestamp
    }
    
} // End of Class
