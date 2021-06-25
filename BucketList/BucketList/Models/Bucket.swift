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
}
extension List: Equatable {
    static func == (lhs: List, rhs: List) -> Bool {
        return lhs.title == rhs.title
    }
}
