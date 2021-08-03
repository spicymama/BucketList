//
//  FriendsListModelController.swift
//  BucketList
//
//  Created by Joshua Hoyle on 6/22/21.
//

import UIKit
import Firebase

class FriendsListModelController {
    
    // MARK: - Properties
    static let sharedInstance = FriendsListModelController()
    var user: [User] = []
    let friendsRef = Firestore.firestore().collection("friends").document(Auth.auth().currentUser!.uid)
    
    //MARK: - CRUD Functions
    func addFriend(newFriendUserID: String) {
        friendsRef.updateData([
            "friends" : FieldValue.arrayUnion([newFriendUserID])
        ])
    } // End of Function add Friend
    
    func removeFriend(friendToRemoveID: String) {
        friendsRef.updateData([
            "friends" : FieldValue.arrayRemove([friendToRemoveID])
        ])
    } // End of Function remove friend
    
    func blockUser(userToBlockID: String) {
        friendsRef.updateData([
            "blocked" : FieldValue.arrayUnion([userToBlockID])
        ])
    } // End of function block user

    func unBlockUser(userToUnblockID: String) {
        friendsRef.updateData([
            "blocked" : FieldValue.arrayRemove([userToUnblockID])
        ])
    } // End of Unblock
    
    func reportUser(userToReportID: String) {
        //TODO(ethan) This should probably do something...
    }
    
} // End of Class
