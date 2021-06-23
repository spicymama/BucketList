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
    var profilePicture: UIImage?
    var allPictures: [UIImage?]
    var bucketIDs: [String]?
    var friendsList: FriendsList?
    var conversationsIDs: [String]
    
    init(firstName: String = "",
         lastName: String = "",
         username: String = "",
         profilePicture: UIImage? = UIImage(),
         allPictures: [UIImage?] = [],
         dob: String = "",
         bucketIDs: [String] = [],
         uid: String = UUID().uuidString,
         friendsList: FriendsList = FriendsList(),
         conversationsIDs: [String] = [])
    {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profilePicture = profilePicture
        self.allPictures = allPictures
        self.dob = dob
        self.bucketIDs = bucketIDs
        self.uid = uid
        self.friendsList = friendsList
        self.conversationsIDs = conversationsIDs
    } // End of initializers
    
} // End of User Class
