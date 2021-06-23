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
    let db = Firestore.firestore()
    static let sharedInstance = FriendsListModelController()
    let uid: String = Auth.auth().currentUser?.uid ?? "0"

    
    //MARK: - CRUD Functions
    func addFriend() {
        checkForBlockedUser()
        let newFriendRef = db.collection("friends").document(uid)
        newFriendRef.updateData([
            "friends": FieldValue.arrayUnion(["CURRENT PROFILE UID HERE"])
        ])
    } // End of Function add Friend
    
    func removeFriend() {
        let unfriendedUserRef = db.collection("friends").document(uid)
        unfriendedUserRef.updateData([
            "friends": FieldValue.arrayRemove(["CURRENT PROFILE UID HERE"])
        ])
    } // End of Function remove friend
    
    func blockUser() {
        // fetchUserData()
        let blockedUserRef = db.collection("friends").document(uid)
        blockedUserRef.updateData([
            "blocked": FieldValue.arrayUnion(["CURRENT PROFILE UID HERE"])
        ])
    } // End of function block user
    
    /* !!! -- This stuff is a WIP -- !!! */
    func checkForBlockedUser() {
        FirebaseFunctions.fetchFriends(uid: uid) { friendsList in
            let blockedUsers: [String] = friendsList.blocked
            print(blockedUsers)
            
            if blockedUsers.contains("current profile uid here") {
                let alertController = UIAlertController(title: "Error adding or messaging user.", message: "Sorry you are unable to add or message this user at this time.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "HOME SCREEN STORYBOARD ID HERE", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: " ")
                //need to change below to the main/home screen.
//                UINavigationController.pushViewController(FriendsTableViewController, animated: true)
            } else {
                
                //If I'm thinking right, this will go back to running the add friends function.
                return
            }
        }
        
        
        /* This is the old stuff, pretty good stuff 🐗*/
        db.collection("friends").getDocuments { QuerySnapshot, error in
            if let error = error {
                print("Error getting documents")
            } else {
                for document in QuerySnapshot!.documents {
                    let blockedUsers = "blocked"
                    print(blockedUsers)
                    
                    
                    if blockedUsers.contains("current profile uid here") {
                        let alertController = UIAlertController(title: "Error adding or messaging user.", message: "Sorry you are unable to add or message this user at this time.", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
//                        self.present(alertController, animated: true, completion: nil)
                        let storyboard = UIStoryboard(name: "HOME SCREEN STORYBOARD ID HERE", bundle: nil)
                        let viewController = storyboard.instantiateViewController(identifier: " ")
                        //need to change below to the main/home screen.
//                        UINavigationController.pushViewController(FriendsTableViewController, animated: true)
                    } else {
                        
                        //If I'm thinking right, this will go back to running the add friends function.
                        return
                    }
                }
            }
        }
    } // End of Check for blocked user
    /* !!! -- This stuff is a WIP -- !!! */
    
} // End of Class
