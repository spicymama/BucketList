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
        let bucketID = bucketID
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
                
                let fetchedBucket = Bucket(title: title, note: note, commentsID: commentsID, itemsID: itemsID, bucketID: bucketID, completion: completion, reactions: reactions, isPublic: isPublic)
                
                🐶(fetchedBucket)
            }
        }
    } // End of Fetch Bucket
    
    
    // MARK: - Fetch Buckets for Users
    static func fetchAllBucketsForUser(userID: String, 🐶: @escaping ( [Bucket] ) -> Void) {
        let userID = userID
        // Get Buckets IDs
        Firestore.firestore().collection("users").document(userID).getDocument { ( snapshot, error ) in
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
                for bucketID in bucketsIDs {
                    group.enter()
                    BucketFirebaseFunctions.fetchBucket(bucketID: bucketID) { bucket in
                        let fetchedBucket: Bucket = bucket
                        
                        // Data to collect
                        
                        let title = fetchedBucket.title
                        let bucketID = fetchedBucket.bucketID!
                        let isPublic = fetchedBucket.isPublic
                        let note = fetchedBucket.note
                        let commentsID = fetchedBucket.commentsID ?? ""
                        let itemsID = fetchedBucket.itemsID ?? ""
                        let completion = fetchedBucket.completion
                        let reactions = fetchedBucket.reactions ?? []
                        
                        let cleanFetchedBucket = Bucket(title: title, note: note, commentsID: commentsID, itemsID: itemsID, bucketID: bucketID, completion: completion, reactions: reactions, isPublic: isPublic)
                        
                        usersBuckets.append(cleanFetchedBucket)
                        
                        group.leave()
                    } // End of fetch Bucket
                } // End of For loop
                group.notify(queue: DispatchQueue.main) {
                    🐶(usersBuckets)
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
            "reactions" : newBucket.reactions as Any
        ]) { error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                // Add new Bucket to User's array of bucketsIDs
                Firestore.firestore().collection("users").document(userID).updateData([
                    "bucketsIDs" : FieldValue.arrayUnion([bucketID])
                ])
                print("Bucket for user \(userID) was created")
            }
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
        Firestore.firestore().collection("buckets").document(bucketID).delete() { error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                // Delete the bucket from the User's array
                Firestore.firestore().collection("users").document(userID).updateData([
                    "bucketIDs" : FieldValue.arrayRemove([bucketID])
                ])
                completion(true)
            }
        }
    } // End of Delete Bucket
    
    
    // MARK: - Fetch Bucket Items
    static func fetchBucketItems(itemsID: String, completion: @escaping ([String : Any])-> Void) {
        let id = itemsID
        let itemsData = Firestore.firestore().collection("bucketItems").document(id)
        itemsData.getDocument { document, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                completion(document!.data()!)
            }
        }
    } // End of Fetch Bucket Items
    
} // End of BucketFirebaseFunctions


