//
//  BucketFirebaseFunctions.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/29/21.
//

import Foundation
import Firebase

class BucketFirebaseFunctions {
    
    
    // MARK: - Fetch All Buckets
    static func fetchAllBuckets(completion: @escaping ([Bucket])-> Void) {
        Firestore.firestore().collectionGroup("buckets").addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else {
                print("No documents")
                return
            }
            if let snapshot = QuerySnapshot {
                var bucketIDs: [String] = []
                for document in snapshot.documents {
                    bucketIDs.append(document.documentID)
                }
                let group = DispatchGroup()
                if bucketIDs.count < 1 {
                    return
                }
                var bucketData: [Bucket] = []
                for i in bucketIDs {
                    group.enter()
                    BucketFirebaseFunctions.fetchBucket(bucketID: i) { data in
                        let fetchedBucket: Bucket = data
                        
                        bucketData.append(fetchedBucket)
                        group.leave()
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    completion(bucketData)
                }
            }
        }
    } // End of Fetch all Buckets
    
    
    // MARK: - Fetch Bucket
    static func fetchBucket(bucketID: String, 🐶: @escaping ( Bucket ) -> Void) {
        if bucketID == "" {
            return
        } else {
            let bucketData = Firestore.firestore().collection("buckets").document(bucketID)
            bucketData.getDocument { document, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    // Data to collect
                    guard let document = document else { return }
                    
                    let title = document["title"] as? String ?? ""
                    let bucketID = document["bucketID"] as? String ?? ""
                    let isPublic = document["isPublic"] as? Bool ?? false
                    let note = document["note"] as? String ?? ""
                    let commentsID = document["commentsID"] as? String ?? ""
                    let itemsID = document["itemsID"] as? String ?? ""
                    let completion = document["completion"] as? Int ?? 0
                    let reactions = document["reactions"] as? [String] ?? []
                    let timestamp = document["timestamp"] as? Date ?? Date()
                    
                    let fetchedBucket = Bucket(title: title, note: note, commentsID: commentsID, itemsID: itemsID, bucketID: bucketID, completion: completion, reactions: reactions, isPublic: isPublic, timestamp: timestamp)
                    
                    🐶(fetchedBucket)
                }
            }
        }
    } // End of Fetch Bucket
    
    
    // MARK: - Fetch Buckets for Users
    static func fetchAllBucketsForUser(userID: String, 🐶: @escaping ( [Bucket] ) -> Void) {
        let userID = userID
        // Get Buckets IDs
        Firestore.firestore().collection("users").document(userID).addSnapshotListener { ( snapshot, error ) in
            if let 🛑 = error {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            } else {
                guard let data = snapshot?.data() else { return }
                var bucketsIDs: [String] = []
                
                // Data to collect
                bucketsIDs = data["bucketsIDs"] as? [String] ?? []
                
                // Fetch Individiual buckets
                let group = DispatchGroup()
                
                var usersBuckets: [Bucket] = []
                if bucketsIDs.count < 1 {
                    return
                } else {
                    for bucketID in bucketsIDs {
                        group.enter()
                        BucketFirebaseFunctions.fetchBucket(bucketID: bucketID) { bucket in
                            let fetchedBucket: Bucket = bucket
                            
                            // Data to collect
                            
                            let title = fetchedBucket.title
                            let bucketID = fetchedBucket.bucketID!
                            let isPublic = fetchedBucket.isPublic
                            let note = fetchedBucket.note ?? ""
                            let commentsID = fetchedBucket.commentsID ?? ""
                            let itemsID = fetchedBucket.itemsID ?? ""
                            let completion = fetchedBucket.completion
                            let reactions = fetchedBucket.reactions ?? []
                            let timestamp = fetchedBucket.timestamp ?? Date()
                            
                            let cleanFetchedBucket = Bucket(title: title, note: note, commentsID: commentsID, itemsID: itemsID, bucketID: bucketID, completion: completion, reactions: reactions, isPublic: isPublic, timestamp: timestamp)
                            
                            usersBuckets.append(cleanFetchedBucket)
                            
                            group.leave()
                        } // End of fetch Bucket
                    } // End of For loop
                    group.notify(queue: DispatchQueue.main) {
                        🐶(usersBuckets)
                    }
                }
            }
        }
    } // End of Fetch all buckets for user
    
    
    // MARK: - Create Bucket
    static func createBucket(newBucket: Bucket) {
        guard let userID: String = Auth.auth().currentUser?.uid else { return }
        let bucketID = UUID().uuidString
        Firestore.firestore().collection("buckets").document(bucketID).setData([
            //Data to store
            "bucketID" : bucketID,
            "completion" : newBucket.completion,
            "title" : newBucket.title,
            "isPublic" : newBucket.isPublic,
            "itemsID" : bucketID,
            "note" : newBucket.note,
            "commentsID" : bucketID,
            "reactions" : newBucket.reactions as Any,
            "timestamp" : FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                // Add new Bucket to User's array of bucketsIDs
                Firestore.firestore().collection("users").document(userID).updateData([
                    "bucketsIDs" : FieldValue.arrayUnion([bucketID])
                ])
                print("Bucket for user \(userID) was created")
                // Create new Bucket Items collection
                Firestore.firestore().collection("bucketItems").document(bucketID).setData([
                    "bucketItemsID" : bucketID
                ])
            } // End of Else statement
        }
    } // End of Create Bucket
    
    
    // MARK: - Update Bucket
    static func updateBucket(bucketToUpdate: Bucket) {
    let bucket = bucketToUpdate
       
        Firestore.firestore().collection("buckets").document(bucket.bucketID!).updateData([
            //Data to store
            "completion" : bucket.completion,
            "title" : bucket.title,
            "isPublic" : bucket.isPublic,
            "note" : bucket.note,
            "reactions" : bucket.reactions as Any
        ]) { error in
            if let 🛑 = error {
                print("Error in \(#function)\(#line) : \(🛑.localizedDescription) \n---\n \(🛑)")
            }
        }
        print("Bucket updated")
    } // End of Update Bucket
    
    
    // MARK: - Delete Bucket
    static func deleteBucket(bucketID: String, completion: @escaping (Bool)-> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        // Delete the bucket from the buckets array
        Firestore.firestore().collection("buckets").document(bucketID).delete() { error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                // Delete the bucket from the User's array
                Firestore.firestore().collection("users").document(userID).updateData([
                    "bucketIDs" : FieldValue.arrayRemove([bucketID])
                ])
                // Delete the Bucket Items
                Firestore.firestore().collection("bucketItems").document(bucketID).delete()
                completion(true)
            }
        }
    } // End of Delete Bucket
    
    
    // MARK: - Create Bucket Item
    static func createBucketItem(bucketItem: BucketItem) {
        let bucketItemsID = bucketItem.bucketID
        let item = bucketItem
        item.itemID = UUID().uuidString
        Firestore.firestore().collection("bucketItems").document(bucketItemsID).collection("bucketItem").document(item.itemID).setData([
            "bucketID" : item.bucketID,
            "title" : item.title,
            "note" : item.note,
            "itemID" : item.itemID,
            "commentsID" : item.commentsID,
            "completed" : item.completed,
            "reactions" : item.reactions,
            "timestamp" : FieldValue.serverTimestamp()
        ])
    } // End of Create Bucket Item
    
    
    // MARK: - Update Bucket Item
    static func updateBucketItem(bucketItem: BucketItem) {
        let bucketItem = bucketItem
        Firestore.firestore().collection("bucketItems").document(bucketItem.bucketID).collection("bucketItem").document(bucketItem.itemID).updateData([
            "title" : bucketItem.title,
            "note" : bucketItem.note,
            "completed" : bucketItem.completed,
            "timestamp" : FieldValue.serverTimestamp()
        ])
        var completed = 0.0
        
        var completion: Double = 0.0
        BucketFirebaseFunctions.fetchBucketItems(bucketItemsID: bucketItem.bucketID) { items in
            for item in items {
                if item.completed == true {
                    completed += 1.0
            }
        }
            if completed > 0.0 {
                completion = (completed / Double(items.count) * 100)
            }
            fetchBucket(bucketID: bucketItem.bucketID) { bucket in
                bucket.completion = Int(completion)
                updateBucket(bucketToUpdate: bucket)
            }
            print(items.count)
            print(completed)
            print(completion)
            completed = 0
        }
        
    } // End of Create Bucket Item
    
    
    // MARK: - Fetch Bucket Items
    static func fetchBucketItems(bucketItemsID: String, 🐶: @escaping ( [BucketItem] )-> Void) {
        Firestore.firestore().collection("bucketItems").document(bucketItemsID).collection("bucketItem") .addSnapshotListener { QuerySnapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                if let snapshot = QuerySnapshot?.documents {
                    let group = DispatchGroup()
                    
                    var fetchedBucketItems: [BucketItem] = []
                    for document in snapshot {
                        group.enter()
                        
                        // Data to collect
                        let bucketID: String = document["bucketID"] as? String ?? ""
                        let title: String = document["title"] as? String ?? ""
                        let note: String = document["note"] as? String ?? ""
                        let itemID: String = document["itemID"] as? String ?? ""
                        let commentsID: String = document["commentsID"] as? String ?? ""
                        let completed: Bool = document["completed"] as? Bool ?? false
                        let reactions: [String] = document["reactions"] as? [String] ?? []
                        
                        let serverTimestamp = document["timestamp"] as? Timestamp
                        let timestamp = serverTimestamp?.dateValue() as! Date
                        
                        let fetchedItem = BucketItem(bucketID: bucketID, title: title, note: note, itemID: itemID, commentsID: commentsID, completed: completed, reactions: reactions, timestamp: timestamp)
                        
                        fetchedBucketItems.append(fetchedItem)
                        group.leave()
                    } // End of For loop
                    group.notify(queue: DispatchQueue.main) {
                        🐶(fetchedBucketItems)
                    } // End of Dispatch Queue notify
                } // End of snapshot
            }
        } // End of Firestore fetch
    } // End of Fetch Bucket Items
    
    
    // MARK: - Delete Bucket Item
    static func deleteBucketItem(bucketItem: BucketItem) -> Void {
        // Bucket ID == Bucket Item ID
        // Delete the item
        Firestore.firestore().collection("bucketItems").document(bucketItem.bucketID).collection("bucketItem").document(bucketItem.itemID).delete()
    } // End of Delete Bucket Item
    
    
} // End of Bucket Firebase Functions


