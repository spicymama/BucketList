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
    var title: String
    var note: String
    var commentsID: String
    var itemsID: String
    
    var bucketID: String = UUID().uuidString
    var completion: Int = 0
    var reactions: [String] = []
    var isPublic: Bool = true
    
    init(title: String, note: String) {
        self.title = title
        self.note = note
        self.commentsID = bucketID
        self.itemsID = bucketID
    }


} // End of Class Bucket

extension List: Equatable {
    static func == (lhs: List, rhs: List) -> Bool {
        return lhs.title == rhs.title
    }
}
