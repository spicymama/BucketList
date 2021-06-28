//
//  FirebaseFunctions.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/15/21.
//

import Foundation
import Firebase

class FirebaseFunctions {
    
    // MARK: - Create User
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
        } // End of base user creation
        
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
        } // End of create users friends list
        
    } // End of Create user Function
    
    
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
    } // End of Function Sign In
    
    
    // MARK: - Fetch Current User Data
    static func fetchCurrentUserData(🐶: @escaping ( User ) -> Void) {
        // Get current user UID
        let uid = Auth.auth().currentUser?.uid
        // Fetch data
        let userData = Firestore.firestore().collection("users").document(uid!)
        userData.getDocument { ( document, 🛑 ) in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                guard let data = document!.data() else { return }
                
                // Data to Collect
                let firstName: String = data["firstName"] as? String ?? "First Name"
                let lastName: String = data["lastName"] as? String ?? "Last Name"
                let username: String = data["username"] as? String ?? "User Name"
                let uid: String = data["uid"] as? String ?? "uid"
                let conversationIDs = data["conversationsID"] as? [String] ?? ["conversationIDs"]
                
                🐶(User(firstName: firstName, lastName: lastName, username: username, uid: uid, conversationsIDs: conversationIDs))
            }
        } // End of getDocument
    } // End of Function fetchData
    
    
    // MARK: - Fetch all Users data
    static func fetchUsersData(passedUserIDs: [String]?, 🐶: @escaping ( [User] ) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snapshot, 🛑 in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
                return 🐶([])
            }
            if let snapshot = snapshot {
                let userIDs: [String] = passedUserIDs ?? fetchAllUsersIDs()
                
                func fetchAllUsersIDs() -> [String] {
                    var allUsersIDs: [String] = []
                    for document in snapshot.documents {
                        allUsersIDs.append(document.documentID)
                    }
                    return allUsersIDs
                }
                
                var usersData: [User] = []
                let group = DispatchGroup()
                
                for i in userIDs {
                    group.enter()
                    FirebaseFunctions.fetchUserData(uid: i) { data in
                        
                        // Any data to return from Firebase
                        let uid = data.uid
                        let firstName = data.firstName
                        let lastName = data.lastName
                        let username = data.username
                        
                        usersData.append(User(firstName: firstName, lastName: lastName, username: username, uid: uid))
                        
                        group.leave()
                    }
                } // End of Loop
                group.notify(queue: DispatchQueue.main) {
                    🐶(usersData)
                }
            } // End of Snapshot
        }
    } // End of FetchUsers Function
    
    
    // MARK: - Fetch User Data
    static func fetchUserData(uid: String ,🐶: @escaping ( User ) -> Void) {
        // Get current user UID
        let uid = uid
        // Fetch data
        let userData = Firestore.firestore().collection("users").document(uid)
        userData.getDocument { ( document, 🛑 ) in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                guard let data = document?.data() else { return }
                
                // Data to collect
                let firstName: String = data["firstName"] as? String ?? "First Name"
                let lastName: String = data["lastName"] as? String ?? "Last Name"
                let username: String = data["username"] as? String ?? "User Name"
                let uid: String = data["uid"] as? String ?? "uid"
                
                let friendsID: String = data["friendsID"] as? String ?? "You have no friends"
                var friendsList = FriendsList()
                FirebaseFunctions.fetchFriends(uid: friendsID) { fetchedFriendsList in
                    friendsList = fetchedFriendsList
                }
                
                🐶(User(firstName: firstName, lastName: lastName, username: username, uid: uid, friendsList: friendsList))
            }
        } // End of getDocument
    } // End of Function fetchData
    
    
    // MARK: - Fetch Friends
    static func fetchFriends(uid: String ,🐶: @escaping ( FriendsList ) -> Void) {
        let group = DispatchGroup()
        group.enter()
        
        // Get current user UID
        let uid = uid
        // Fetch data
        let userData = Firestore.firestore().collection("friends").document(uid)
        userData.getDocument { ( document, 🛑 ) in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                guard let data = document?.data() else { return }
                
                let friends: [String] = data["friends"] as? [String] ?? []
                let blocked: [String] = data["blocked"] as? [String] ?? []
                
                group.notify(queue: DispatchQueue.main) {
                    🐶(FriendsList(friends: friends, blocked: blocked))
                }
            }
        } // End of Get Document
    } // End of Function fetch friends
    
    
    // MARK: - Create Post
    static func createPost(note: String, imageID: String, bucketID: String, bucketItemID: String) {
        guard let currentUserID: String = Auth.auth().currentUser?.uid else { return }
        let postID = UUID().uuidString
        Firestore.firestore().collection("posts").document(postID).setData( [
            "authorID" : currentUserID,
            "timeStamp" : Date(),
            "postNote" : note,
            "photoID" : imageID,
            "bucketID" : bucketID,
            "bucketItemID" : bucketItemID,
            "commentsID" : postID,
            "reactionsArr" : []
        ]) { err in
            if let err = err {
                print("Error in \(#function)\(#line) : \(err.localizedDescription) \n---\n \(err)")
            } else {
                // Make the comments Document
                Firestore.firestore().collection("comments").document(postID).setData([
                    "referenceID" : postID
                ])
                Firestore.firestore().collection("comments").document(postID).collection("comment")
                
                // Add the post to the Bucket's array of post ID's if it exists
                if bucketID != "" {
                    // Add this post ID to the Bucket Post array
                    Firestore.firestore().collection("buckets").document(bucketID).updateData([
                        "postsIDs" : FieldValue.arrayUnion([postID])
                    ])
                    print("PostID added to Bucket")
                }
                // Add the post to the BucketItems's array of post ID's if it exists
                if bucketItemID != "" {
                    // Add this post ID to the BucketItem post array
                    Firestore.firestore().collection("bucketItems").document(bucketItemID).updateData([
                        "postsIDs" : FieldValue.arrayUnion([postID])
                    ])
                    print("PostID added to BucketItem")
                }
                print("Post for user \(currentUserID) was created")
            }
        }
    } // End of Create Post
    
    
    // MARK: - Fetch All Posts
    static func fetchAllPosts(completion: @escaping ([Post] ) -> Void) {
        Firestore.firestore().collectionGroup("posts").addSnapshotListener { (QuerySnapshot, error) in
            if let snapshot = QuerySnapshot {
                var postIDs: [String] = []
                for document in snapshot.documents {
                    postIDs.append(document.documentID)
                }
                let group = DispatchGroup()
                
                var postsData: [Post] = []
                for i in postIDs {
                    group.enter()
                    FirebaseFunctions.fetchPost(postID: i) { data in
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
        } // End of Firestore function
    } // End of Fetch all posts
    
    
    // MARK: - FetchPost
    static func fetchPost(postID: String, 🐶: @escaping ( [String : Any]) -> Void) {
        let id = postID
        let data = Firestore.firestore().collection("posts").document(id)
        data.getDocument { (document, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                🐶(document!.data()!)
            }
        }
    } // End of Fetch Post
    
    
    // MARK: - Create Bucket
    
    
    // MARK: - Create Bucket Item
    
    
    // MARK: - Fetch All Bucket Items
    static func fetchAllBucketItems(itemsID: String, 🐶: @escaping ( [BucketItem] ) -> Void) {
        // Get the proper collection of items associated with the itemsID
        Firestore.firestore().collection("bucketItems").document(itemsID).collection("items").addSnapshotListener { (QuerySnapshot, error) in
            if let snapshot = QuerySnapshot {
                var itemIDs: [String] = []
                for document in snapshot.documents {
                    itemIDs.append(document.documentID)
                }
                // Make a Dispatch group for loading the objects
                let group = DispatchGroup()
                
                // Grab all of the item documents as BucketItem objects
                var itemsData: [BucketItem] = []
                for itemID in itemIDs {
                    group.enter()
                    let data = Firestore.firestore().collection("bucketItems").document(itemsID).collection("items").document(itemID)
                    data.getDocument { (document, 🛑) in
                        if let 🛑 = 🛑 {
                            print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
                        } else {
                            guard let document = document else { return }
                            let bucketID: String = document["bucketID"] as! String
                            let commentsID: String = document["commentsID"] as! String
                            let completed: Bool = document["completed"] as! Bool
                            let itemID: String = document["itemID"] as! String
                            let note: String = document["note"] as! String
                            let reactions: [String] = document["reactions"] as! [String]
                            let title: String = document["title"] as! String
                            
                            let item = BucketItem(bucketID: bucketID, title: title, note: note, itemID: itemID, commentsID: commentsID, completed: completed, reactions: reactions)
                            itemsData.append(item)
                            group.leave()
                        }
                    }
                    group.notify(queue: DispatchQueue.main) {
                        🐶(itemsData)
                    }
                } // End of item in items loop
            } // End of Query snapshot
            // Return an array of BucketItem variables
        } // End of Function
    }
    
    // MARK: - Fetch Buckets
    
} // End of Class
