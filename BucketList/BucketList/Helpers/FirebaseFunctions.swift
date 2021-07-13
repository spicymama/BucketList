//
//  FirebaseFunctions.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/15/21.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseFunctions {
    var sourceOfTruth: FriendsList = FriendsList()
    
    // MARK: - Username is avaliable checker
    static func usernameIsAvaliable(username: String, 🐶: @escaping ( Bool ) -> Void) {
        var usernameIsAvaliable: Bool = false
        Firestore.firestore().collection("users").getDocuments { QuerySnapshot, 🛑 in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                guard let snapshot = QuerySnapshot else { return }
                let group = DispatchGroup()
                
                let username: String = username.lowercased()
                var failCount: Int = 0
                
                for document in snapshot.documents {
                    group.enter()
                    let fetchedUsername: String = document["username"] as? String ?? ""
                    if username == fetchedUsername.lowercased() {
                        failCount += 1
                    }
                    group.leave()
                } // End of For loop
                if failCount == 0 {
                    usernameIsAvaliable = true
                }
                group.notify(queue: DispatchQueue.main) {
                    🐶(usernameIsAvaliable)
                }
            } // End of Username is avaliable check
        }
    } // End of Username Is Avaliable
    
    // MARK: - Create User
    static func createUser(email: String, password: String, firstName: String, lastName: String, dob: Date, username: String) {
        // This creates the user
        var newUserID: String = ""
        Auth.auth().createUser(withEmail: email, password: password) { result, 🛑 in
            // Check for errors
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                newUserID = result!.user.uid
                let data = [
                    "uid" : newUserID,
                    "friendsListID" : newUserID,
                    "conversationsID" : [""],
                    "bucketsIDs" : [""],
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
                // This creates the base user's friends lis
                Firestore.firestore().collection("friends").document(newUserID).setData( [
                    "friends" : [""],
                    "blocked" : [""]
                ]) { err in
                    if let err = err {
                        print("Error in \(#function)\(#line) : \(err.localizedDescription) \n---\n \(err)")
                    } else {
                        print("Friend list for user \(newUserID) was created")
                    }
                } // End of create users friends list
            }
        } // End of base user creation
        
<<<<<<< HEAD
<<<<<<< HEAD
        // This creates the base user's friends list
        let uid = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("friends").document(uid).setData( [
            "friends" : [""],
            "blocked" : [""]
        ]) { err in
            if let err = err {
                print("Error in \(#function)\(#line) : \(err.localizedDescription) \n---\n \(err)")
            } else {
                print("Friend list for user \(uid) was created")
            }
        } // End of create users friends list
        
=======
>>>>>>> 7f675c7240c1089c5283b9fbbd99c4560512a834
=======
>>>>>>> 7f675c7240c1089c5283b9fbbd99c4560512a834
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
                let group = DispatchGroup()
                group.enter()
                // Data to Collect
                let firstName: String = data["firstName"] as? String ?? "First Name"
                let lastName: String = data["lastName"] as? String ?? "Last Name"
                let username: String = data["username"] as? String ?? "User Name"
                let uid: String = data["uid"] as? String ?? "uid"
                let conversationIDs = data["conversationsID"] as? [String] ?? ["conversationIDs"]
                let profilePicURL = data["profilePicURL"] as? String
                
                let user = User(firstName: firstName, lastName: lastName, username: username, profilePicUrl: profilePicURL, uid: uid, conversationsIDs: conversationIDs)
                🐶(user)
                
                group.leave()
            }
            
        } // End of getDocument
    } // End of Function fetchData
    
    static func fetchCurrentUser(completion: @escaping ( User )-> Void) {
        let uid = Auth.auth().currentUser?.uid
        let userData = Firestore.firestore().collection("users").document(uid!)
        userData.getDocument { ( document, error ) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                guard let data = document!.data() else { return }
                let group = DispatchGroup()
                group.enter()
                // Data to Collect
                let firstName: String = data["firstName"] as? String ?? "First Name"
                let lastName: String = data["lastName"] as? String ?? "Last Name"
                let username: String = data["username"] as? String ?? "User Name"
                let uid: String = data["uid"] as? String ?? "uid"
                let conversationIDs = data["conversationsID"] as? [String] ?? ["conversationIDs"]
                let profilePicURL = data["profilePicURL"] as? String
                let friendsListID = data["friendsListID"] as? String ?? "No friends"
                
                let fetchedUser = User(firstName: firstName, lastName: lastName, username: username, profilePicUrl: profilePicURL, uid: uid, friendsListID: friendsListID, conversationsIDs: conversationIDs)
                
                completion(fetchedUser)
                group.leave()
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
    static func fetchUserData(uid: String, 🐶: @escaping ( User ) -> Void) {
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
                let profilePicURL = data["profilePicUrl"] as? String ?? "defaultProfileImage"
                let friendsListID: String = data["friendsID"] as? String ?? "You have no friends"
                
                🐶(User(firstName: firstName, lastName: lastName, username: username, profilePicUrl: profilePicURL, uid: uid, friendsListID: friendsListID))
            }
        } // End of getDocument
    } // End of Function fetchData
    
    
    // MARK: - Fetch Friends
    static func fetchFriends(friendsListID: String ,completion: @escaping ( FriendsList ) -> Void) {
        let group = DispatchGroup()
        group.enter()
        
        // Fetch data
        let userData = Firestore.firestore().collection("friends").document(friendsListID)
        userData.getDocument {  document, error  in
            if let error = error {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                guard let data = document?.data() else { return }
                
                let friends: [String] = data["friends"] as? [String] ?? []
                let blocked: [String] = data["blocked"] as? [String] ?? []
                group.leave()
                
                group.notify(queue: DispatchQueue.main) {
                    completion(FriendsList(friends: friends, blocked: blocked))
                }
            }
        } // End of Get Document
    } // End of Function fetch friends
    
    
    // MARK: - Create Post
    static func createPost(newPost: Post, image: UIImage?) {
        guard let currentUserID: String = Auth.auth().currentUser?.uid else { return }
        let postID: String = UUID().uuidString
        let storage = Storage.storage().reference()
        let ref = storage.child("images/\(postID).post.jpeg")
        
        var urlString: String = ""
        if image != nil {
            let imageData = image!.jpegData(compressionQuality: 0.25)!
            ref.putData(imageData, metadata: nil) { _, 🛑 in
                if let 🛑 = 🛑 {
                    print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
                    return
                }
            }
        }
        ref.downloadURL(completion:) { url, 🛑 in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            }
            urlString = url?.absoluteString ?? ""
        }
        
        Firestore.firestore().collection("posts").document(postID).setData([
            "postID" : postID,
            "authorID" : currentUserID,
            "timestamp" : FieldValue.serverTimestamp(),
            "note" : newPost.note,
            "imageURL" : urlString,
            "bucketID" : newPost.bucketID ?? "",
            "bucketTitle" : newPost.bucketTitle ?? "",
            "commentsID" : newPost.postID,
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
                if newPost.bucketID != "" {
                    // Add this post ID to the Bucket Post array
                    Firestore.firestore().collection("buckets").document(newPost.bucketID!).updateData([
                        "postsIDs" : FieldValue.arrayUnion([postID])
                    ])
                    print("PostID added to Bucket")
                }
                print("Post for user \(currentUserID) was created")
            }
        }
    } // End of Create Post
    
    
    
    // MARK: - Edit Post
    static func editPost(postID: String?, note: String, imageID: String, bucketID: String, oldBucketID: String, bucketTitle: String) {
        guard let postID = postID else { return }
        Firestore.firestore().collection("posts").document(postID).updateData( [
            "editedTimestamp" : FieldValue.serverTimestamp(),
            "note" : note,
            "photoID" : imageID,
            "bucketID" : bucketID,
            "bucketTitle" : bucketTitle,
            "commentsID" : postID,
            "reactionsArr" : []
        ]) { err in
            if let err = err {
                print("Error in \(#function)\(#line) : \(err.localizedDescription) \n---\n \(err)")
            } else {
                // Add the post to the Bucket's array of post ID's if it exists, or update, or delete
                if oldBucketID != bucketID {
                    if bucketID != "" {
                        // Remove postID from old Bucket post array
                        Firestore.firestore().collection("buckets").document(oldBucketID).updateData([
                            "postIDs" : FieldValue.arrayRemove([oldBucketID])
                        ])
                        // Add this post ID to new Bucket Post array
                        Firestore.firestore().collection("buckets").document(bucketID).updateData([
                            "postsIDs" : FieldValue.arrayUnion([postID])
                        ])
                    } // End of if Post has a Bucket
                } // End of if Bucket ID was changed
            }
        }
    } // End of Create Post
    
    
    // MARK: - Fetch All Posts
    static func fetchAllPosts(completion: @escaping ( [Post] ) -> Void) {
        Firestore.firestore().collectionGroup("posts").addSnapshotListener { (QuerySnapshot, error) in
            if let snapshot = QuerySnapshot {
                var postIDs: [String] = []
                for document in snapshot.documents {
                    postIDs.append(document.documentID)
                }
                let group = DispatchGroup()
                
                var postsData: [Post] = []
                for postID in postIDs {
                    group.enter()
                    FirebaseFunctions.fetchPost(postID: postID) { post in
                        let fetchedPost: Post = post
                        
                        // Data to collect
                        let postID: String = fetchedPost.postID ?? ""
                        let authorID: String = fetchedPost.authorID ?? ""
                        let note: String = fetchedPost.note ?? ""
                        let commentsID: String = fetchedPost.commentsID ?? ""
                        let imageURL: String = fetchedPost.imageURL ?? ""
                        let bucketID: String = fetchedPost.bucketID ?? ""
                        let bucketTitle: String = fetchedPost.bucketTitle ?? ""
                        //  let timestamp: Date = fetchedPost.timestamp
                        
                        let post = Post(postID: postID, authorID: authorID, note: note, commentsID: commentsID, imageURL: imageURL, bucketID: bucketID, bucketTitle: bucketTitle)
                        
                        postsData.append(post)
                        group.leave()
                    } // End of Post in Posts Loop
                    group.notify(queue: DispatchQueue.main) {
                        completion(postsData)
                    }
                } // End of Fetch Post
            }
        } // End of Firestore function
    } // End of Fetch all posts
    
    
    // MARK: - FetchPost
    static func fetchPost(postID: String, 🐶: @escaping ( Post ) -> Void) {
        let id = postID
        let data = Firestore.firestore().collection("posts").document(id)
        data.getDocument { (document, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                guard let data = document else { return }
                
                // Data to collect
                let postID: String = data["postID"] as? String ?? ""
                let authorID: String = (data["authorID"] as? String) ?? ""
                let note: String = data["note"] as? String ?? ""
                let commentsID: String = data["commentsID"] as? String ?? ""
                let imageURL: String = data["imageURL"] as? String ?? ""
                let bucketID: String = data["bucketID"] as? String ?? ""
                let bucketTitle: String = data["bucketTitle"] as? String ?? ""
                let timestamp: Date = data["timestamp"] as? Date ?? Date()
                
                let fetchedPost = Post(postID: postID, authorID: authorID, note: note, commentsID: commentsID, imageURL: imageURL, bucketID: bucketID, bucketTitle: bucketTitle)
                
                🐶(fetchedPost)
            }
        }
    } // End of Fetch Post
    
    
    // MARK: - Fetch all posts for user
    static func fetchAllPostsForUser(userID: String, 🐶: @escaping ( [Post] ) -> Void) {
        Firestore.firestore().collectionGroup("posts").addSnapshotListener { (QuerySnapshot, error) in
            if let 🛑 = error {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                if let snapshot = QuerySnapshot {
                    var postIDs: [String] = []
                    for document in snapshot.documents {
                        if userID == document["authorID"] as? String {
                            postIDs.append(document["postID"] as? String ?? "")
                        }
                    }
                    let group = DispatchGroup()
                    
                    var postsData: [Post] = []
                    for postID in postIDs {
                        group.enter()
                        FirebaseFunctions.fetchPost(postID: postID) { post in
                            let fetchedPost: Post = post
                            
                            // Data to collect
                            let postID: String = fetchedPost.postID ?? ""
                            let authorID: String = fetchedPost.authorID ?? ""
                            let note: String = fetchedPost.note ?? ""
                            let commentsID: String = fetchedPost.commentsID ?? ""
                            let imageURL: String = fetchedPost.imageURL ?? ""
                            let bucketID: String = fetchedPost.bucketID ?? ""
                            let bucketTitle: String = fetchedPost.bucketTitle ?? ""
                            // let timestamp: Date = fetchedPost.timestamp
                            
                            let post = Post(postID: postID, authorID: authorID, note: note, commentsID: commentsID, imageURL: imageURL, bucketID: bucketID, bucketTitle: bucketTitle)
                            
                            postsData.append(post)
                            
                            group.leave()
                        } // End of Fetch Post
                    } // End of Post in Posts Loop
                    group.notify(queue: DispatchQueue.main) {
                        🐶(postsData)
                    }
                }
            }
        } // End of Firestore function
    } // End of Fetch All posts for Users
    
    
    // MARK: - Delete Post
    static func deletePost(postID: String) {
        Firestore.firestore().collection("posts").document(postID).delete() { 🛑 in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                print("Post deleted")
            }
        }
    } // End of Delete Post
    
    
    // MARK: - Post Comment
    static func postComment(comment: Comment) {
        let authorID: String = comment.authorID ?? ""
        let commentsID: String = comment.commentsID ?? ""
        let commentID: String = comment.commentID ?? ""
        let authorUsername: String = comment.authorUsername ?? ""
        
        Firestore.firestore().collection("comments").document(commentsID).collection("comment").document(commentID).setData([
            "commentsID" : commentsID,
            "commentID" : commentID,
            "authorID" : authorID,
            "authorUsername" : authorUsername,
            "timestamp" : FieldValue.serverTimestamp(),
            "note" : comment.note
        ])
        print("Comment posted")
    } // End of Post comment
    
    
    // MARK: - Fetch Comments
    static func fetchCommentsData(postID: String, 🐶: @escaping ( [Comment] ) -> Void) {
        Firestore.firestore().collection("comments").document(postID).collection("comment").addSnapshotListener { QuerySnapshot, 🛑 in
            if let 🛑 = 🛑 {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                if let snapshot = QuerySnapshot {
                    var commentsData: [Comment] = []
                    
                    for document in snapshot.documents {
                        let data = document.data()
                        
                        // Data to collect
                        let authorID: String = data["authorID"] as? String ?? ""
                        let authorUsername: String = data["authorUsername"] as? String ?? ""
                        let commentID: String = data["commentID"] as? String ?? ""
                        let commentsID: String = data["commentsID"] as? String ?? ""
                        let note: String = data["note"] as? String ?? ""
                        let timestamp: String = data["timestamp"] as? String ?? ""
                        
                        let fetchedComment = Comment(commentsID: commentsID, commentID: commentID, authorID: authorID, timestamp: timestamp, authorUsername: authorUsername, note: note)
                        
                        commentsData.append(fetchedComment)
                    }
                    🐶(commentsData)
                } // End of Snapshot in query snapshot
            }
        } // End of snapshot listener
    } // End of Function fetchComments
    
    
    // MARK: - Fetch Profile Picture
    static func fetchProfileImage(user: User, 🐶: @escaping ( UIImage ) -> Void) {
        guard let profilePicUrl: URL = URL(string: user.profilePicUrl ?? "") else { return }
        
        let task = URLSession.shared.dataTask(with: profilePicUrl, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                print("Error in (#function)(#line)")
                return
            }
            DispatchQueue.main.async {
                let fetchedImage: UIImage = UIImage(data: data) ?? UIImage(named: "defaultProfileImage") as! UIImage
                🐶(fetchedImage)
            } // End of Dispatch Queue
        })
        task.resume()
    } // End of Fetch Profile Image
    
} // End of Class





// guard let comments: [String] = data["commentsArr"] as? [String] else {return}
//PostViewController.comments = comments
//print(comments)
