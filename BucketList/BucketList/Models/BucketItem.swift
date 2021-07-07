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
    
    init(bucketID: String, title: String, note: String, itemID: String = UUID().uuidString, commentsID: String, completed: Bool = false, reactions: [String] = []) {
        self.bucketID = bucketID
        self.title = title
        self.note = note
        self.itemID = itemID
        self.commentsID = itemID
        self.completed = completed
        self.reactions = reactions
    }
    
} // End of Class
