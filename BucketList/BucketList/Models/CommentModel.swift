//
//  CommentModel.swift
//  BucketList
//
//  Created by Ethan Andersen on 7/5/21.
//

import Foundation

struct Comment {
    
    /// Comments ID is the same as the PostsID or the BucketID
    let commentsID: String?
    let commentID: String?
    let authorID: String?
    let authorUsername: String?
    let timestamp: Date?
    let note: String
    
    init(commentsID: String, commentID: String = UUID().uuidString, authorID: String = "", timestamp: Date = Date(), authorUsername: String, note: String) {
        self.commentsID = commentsID
        self.commentID = commentID
        self.authorID = authorID
        self.authorUsername = authorUsername
        self.timestamp = timestamp
        self.note = note
    }
    
} // End of Class
