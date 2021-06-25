//
//  Friend.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/24/21.
//

import UIKit

class Friend {
    let firstName: String
    let lastName: String
    let username: String
    let uid: String
    
    
    init(firstName: String, lastName: String, username: String, uid: String, profilePicutre: UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.uid = uid
         
        
        
    }
}
