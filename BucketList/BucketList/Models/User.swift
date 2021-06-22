//
//  User.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/21/21.
//

import UIKit
import Firebase

class User {
    let name: String
    let username: String
    let profilePicture: UIImage?
    let allPictures: [UIImage?]
    let goals: [String]
    let acheivements: [String]
    
    init(name: String, username: String, profilePicture: UIImage?, allPictures: [UIImage?], goals: [String], acheivements: [String]) {
    self.name = name
        self.username = username
        self.profilePicture = profilePicture
        self.allPictures = allPictures
        self.goals = goals
        self.acheivements = acheivements
    }
    
}
