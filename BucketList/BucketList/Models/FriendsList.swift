//
//  Friend.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/23/21.
//

import Foundation

struct FriendsList {
    
    // MARK: - Properties
    var friends: [String]
    var blocked: [String]
    
    init(friends: [String] = [],
         blocked: [String] = [])
    {
        self.friends = friends
        self.blocked = blocked
    }

} // End of Struct Friends List

