//
//  User.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit
import Firebase

class User {
    var uid: String
    var username: String
    var firstName: String
    var lastName: String
    var dob: String?
    var profilePicUrl: String?
    var bucketIDs: [String]?
    var friendsListID: String?
    var conversationsIDs: [String]
    
    init(firstName: String = "",
         lastName: String = "",
         username: String = "",
         profilePicUrl: String? = "",
         dob: String = "",
         bucketIDs: [String] = [],
         uid: String = UUID().uuidString,
         friendsListID: String = "",
         conversationsIDs: [String] = [])
    {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profilePicUrl = profilePicUrl
        self.dob = dob
        self.bucketIDs = bucketIDs
        self.uid = uid
        self.friendsListID = friendsListID
        self.conversationsIDs = conversationsIDs
    } // End of initializers
    
} // End of User Class
