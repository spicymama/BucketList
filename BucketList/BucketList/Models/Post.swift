//
//  Post.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/22/21.
//

import UIKit

class Post {

    let postID: String
    let authorID: String
    let note: String
    let commentsID: String
    let photoID: String
    let bucketID: String?
    let bucketTitle: String?
    let timestamp: Date
    
    init(postID: String, authorID: String, note: String, commentsID: String, photoID: String, bucketID: String, bucketTitle: String, timestamp: Date) {
        self.postID = postID
        self.authorID = authorID
        self.note = note
        self.commentsID = commentsID
        self.photoID = photoID
        self.bucketID = bucketID
        self.bucketTitle = bucketTitle
        self.timestamp = timestamp
    }
    
}
extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.postID == rhs.postID
    }
}
