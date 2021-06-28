//
//  Post.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/22/21.
//

import UIKit

class Post {
    
    let commentsID: String
    let photoID: String
    let description: String
    let title: String
    let creatorID: String
    
    init(commentsID: String, photoID: String, description: String, title: String, creatorID: String) {
        self.commentsID = commentsID
        self.photoID = photoID
        self.description = description
        self.title = title
        self.creatorID = creatorID
    }
    
}
