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
    let db = Firestore.firestore()
    let loggedInUserID: String = Auth.auth().currentUser?.uid ?? "0"
    
    
    //MARK: - CRUD Functions
    func addFriend(newFriendUserID: String) {
        checkForBlockedUser(userID: newFriendUserID)
        let newFriendRef = db.collection("friends").document(loggedInUserID)
        newFriendRef.updateData([
            "friends": FieldValue.arrayUnion(["CURRENT PROFILE UID HERE"])
        ])
    } // End of Function add Friend
    
    func removeFriend() {
        let unfriendedUserRef = db.collection("friends").document(loggedInUserID)
        unfriendedUserRef.updateData([
            "friends": FieldValue.arrayRemove(["CURRENT PROFILE UID HERE"])
        ])
    } // End of Function remove friend
    
    func blockUser(profileUID: String) {
        let arrayProfileID: [String] = [profileUID]
        FirebaseFunctions.fetchUserData(uid: loggedInUserID) { data in
            let blockedUserRef = self.db.collection("friends").document(self.loggedInUserID)
            blockedUserRef.updateData([
                "blocked": FieldValue.arrayUnion(arrayProfileID)
            ])
        }
    } // End of function block user
    
    /* !!! -- This stuff is a WIP -- !!! */
    func checkForBlockedUser(userID: String) {
        // Check the logged in user's blocked list, make sure the friend isn't on it
        FirebaseFunctions.fetchFriends(uid: loggedInUserID) { friendsList in
            let blockedUsers: [String] = friendsList.blocked
            print(blockedUsers)
            
            if blockedUsers.contains(self.loggedInUserID) {
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
