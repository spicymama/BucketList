//
//  UserController.swift
//  BucketList
//
//  Created by Justin Webster on 6/22/21.
//
import Foundation
class UserController {
    
    static var shared = UserController()
    var currentUser: User = ConversationController.shared.currentUser!
    
}//End of Class
