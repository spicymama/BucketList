//
//  User.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/21/21.
//

import UIKit
import Firebase

class User {
    var firstName: String
    var lastName: String
    var username: String
    var profilePicture: UIImage?
    var allPictures: [UIImage?]
    var bucketIDs: [String]
    var uid: String
    var dob: Timestamp
    
    
    init(firstName: String, lastName: String, username: String, profilePicture: UIImage?, allPictures: [UIImage?], dob: Timestamp, bucketIDs: [String], uid: String = UUID().uuidString) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profilePicture = profilePicture
        self.allPictures = allPictures
        self.dob = dob
        self.bucketIDs = bucketIDs
        self.uid = uid
    }
}
