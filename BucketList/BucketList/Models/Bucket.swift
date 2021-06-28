//
//  Bucket.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//
import Foundation

class List {
    var title: String
    var list: [String]
    
    init(title: String, list: [String]) {
        self.title = title
        self.list = list
    }
} // End of Class List

class Bucket {
    var bucketID: String = UUID().uuidString
    var title: String
    var note: String
    var itemsID: String
    var completion: Int = 0
    var reactions: [String] = []
    var commentsID: String
    var isPublic: Bool = true
    
    init(title: String, note: String) {
        self.title = title
        self.note = note
        self.itemsID = bucketID
        self.commentsID = bucketID
    }
    
} // End of Class Bucket
