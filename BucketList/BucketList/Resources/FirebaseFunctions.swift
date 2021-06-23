//
//  FirebaseFunctions.swift
//  Authenticator
//
//  Created by Ethan Andersen on 6/15/21.
//

import Foundation
import Firebase

class FirebaseFunctions {
    
    static func createUser(email: String, password: String, firstName: String, lastName: String, dob: Date, username: String) {
        // This creates the user
        Auth.auth().createUser(withEmail: email, password: password) { result, 🛑 in
            // Check for errors
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                let data = [
                    "uid" : result!.user.uid,
                    "friendsID" : result!.user.uid,
                    "conversationsID" : [""],
                    "bucketsID" : [""],
                    "username" : username,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "dob" : dob,
                ] as [String : Any]
                
                // This is the only real important line, adds the user, and sets their collection ID to their userID
                Firestore.firestore().collection("users").document((result!.user.uid)).setData(data) { 🛑 in
                    if let 🛑 = 🛑 {
                        print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
                    }
                }
            }
        } // End of Auth check
    } // End of Create user Function
    
    static func createBucket(title: String, items: [String]) {
        let uid = Auth.auth().currentUser?.uid
        let bucketID = UUID().uuidString
        Firestore.firestore().collection("buckets").document(bucketID).setData( [
            "title" : title,
            "items" : items,
            "timeStamp" : Date()
        ]) { err in
            if let err = err {
                print("Error in \(#function)\(#line) : \(err.localizedDescription) \n---\n \(err)")
            } else {
                print("Bucket \(uid ?? "") was created")
            }
        }
    }
    
    // MARK: - Sign in
    static func signInUser(email: String, password: String, 🐶: @escaping (Result <Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, 🛑 in
            switch result {
            case .none:
                if let 🛑 = 🛑 {
                    print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
                    🐶(.failure(🛑))
                }
            case .some(_):
                🐶(.success(true))
            }
        } // End of Auth
        
        
        // This creates the base user's friends list
        let uid = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("friends").document(uid!).setData( [
            "friends" : [""],
            "blocked" : [""]
        ]) { err in
            if let err = err {
                print("Error in \(#function)\(#line) : \(err.localizedDescription) \n---\n \(err)")
            } else {
                print("Friend list for user \(uid!) was created")
            }
        } // End of Setup account stuff
    } // End of Function Sign In
    
    
    // MARK: - Fetch Data
    static func fetchCurrentUserData(🐶: @escaping ( [String : Any] ) -> Void) {
        // Get current user UID
        let uid = Auth.auth().currentUser?.uid
        // Fetch data
        let userData = Firestore.firestore().collection("users").document(uid!)
        userData.getDocument { ( document, 🛑 ) in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                // dataInfo is the user information
                🐶(document!.data()!)
            }
        } // End of getDocument
    } // End of Function fetchData
    
    static func fetchUsersData(completion: @escaping ( [User] ) -> Void) {
        Firestore.firestore().collectionGroup("users").addSnapshotListener { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents
            else {
                print("No Documents")
                return
            }
            if let snapshot = QuerySnapshot {
                var userIds: [String] = []
                for document in snapshot.documents {
                    userIds.append(document.documentID)
                }
                let group = DispatchGroup()
                
                var usersData: [User] = []
                for i in userIds {
                    group.enter()
                    FirebaseFunctions.fetchUserData(uid: i) { data in
                        // Any data to return from Firebase
                        
                        let allPictures = [UIImage(named: "swing")]
                        let bucketIDs = data["bucketsID"] as! [String]
                        let firstName = data["firstName"] as! String
                        let lastName = data["lastName"] as! String
                        let dob = data["dob"] as! Timestamp
                        let username = data["username"] as! String
                        let profilePicture = UIImage(named: "peace")
                        
                       let fetchedUser = User(firstName: firstName, lastName: lastName, username: username, profilePicture: profilePicture, allPictures: allPictures, dob: dob, bucketIDs: bucketIDs)
                   
                        usersData.append(fetchedUser)
                        print(fetchedUser.firstName)
                        
                        group.leave()
                    }
                } // End of Loop
                group.notify(queue: DispatchQueue.main) {
                    completion(usersData)
                }
            } // End of Snapshot
        }
    } // End of FetchUsers Function
    
    static func fetchUserData(uid: String, completion: @escaping ( [String : Any] ) -> Void) {
        // Get current user UID
        let uid = uid
        // Fetch data
        let userData = Firestore.firestore().collection("users").document(uid)
        userData.getDocument { ( document, error ) in
            if let error = error {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                // dataInfo is the user information
                completion(document!.data()!)
                
            }
        } // End of getDocument
    } // End of Function fetchData
    
    
    static func createPost(title: String, description: String, imageID: String, progress: Bool) {
        
        let uid = Auth.auth().currentUser?.uid
        let postID = UUID().uuidString
        Firestore.firestore().collection("posts").document(postID).setData( [
            "commentsID" : postID,
            "creatorID" : uid!,
            "photoID" : imageID,
            "title" : title,
            "postNote" : description,
            "reactionsArr" : [],
            "timeStamp" : Date()
        ]) { err in
            if let err = err {
                print("Error in \(#function)\(#line) : \(err.localizedDescription) \n---\n \(err)")
            } else {
                print("Post for user \(uid ?? "") was created")
            }
        }
    }
    
    static func fetchAllPosts(completion: @escaping ([Post] ) -> Void) {
        Firestore.firestore().collectionGroup("posts").addSnapshotListener { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else {
                print("No Documents")
                return
            }
            if let snapshot = QuerySnapshot {
                var postIDs: [String] = []
                for document in snapshot.documents {
                    postIDs.append(document.documentID)
                }
                let group = DispatchGroup()
                
                var postsData: [Post] = []
                for i in postIDs {
                    group.enter()
                    FirebaseFunctions.fethPost(uid: i) { data in
                        let postID: String = data["commentsID"] as! String
                        let postDecription: String = data["postNote"] as! String
                        let postTitle: String = data["title"] as? String ?? "Title"
                        let photoID: String = "swing"
                        let creatorID: String = (data["creatorID"] as? String)!
                        let post = Post(commentsID: postID, photoID: photoID, description: postDecription, title: postTitle, creatorID: creatorID)
                        postsData.append(post)
                        group.leave()
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    completion(postsData)
                }
            }
        }
    }
    
    static func fethPost(uid: String, completion: @escaping ( [String : Any])-> Void) {
        let uid = uid
        let postData = Firestore.firestore().collection("posts").document(uid)
        postData.getDocument { (document, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                completion(document!.data()!)
            }
        }
    }
} // End of Class

