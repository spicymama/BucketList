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
                
                let title = document["title"] as! String
                let bucketID = document["bucketID"] as! String
                let isPublic = document["isPublic"] as! Bool
                let note = document["note"] as! String
                let commentsID = document["commentsID"] as! String
                let itemsID = document["itemsID"] as! String
                let completion = document["completion"] as! Int
                let reactions = document["reactions"] as! [String]
                
                let fetchedBucket = Bucket(title: title, note: note, commentsID: commentsID, itemsID: itemsID, bucketID: bucketID, completion: completion, reactions: reactions, isPublic: isPublic)
                
                🐶(fetchedBucket)
            }
        }
    } // End of Fetch Bucket
    
    
    // MARK: - Create Bucket
    static func createBucket(newBucket: Bucket) {
        guard let userID: String = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("buckets").document(newBucket.bucketID).setData([
            //Data to store
            "bucketID" : newBucket.bucketID,
            "completion" : newBucket.completion,
            "title" : newBucket.title,
            "isPublic" : newBucket.isPublic,
            "itemsID" : newBucket.itemsID,
            "note" : newBucket.note,
            "commentsID" : newBucket.commentsID,
            "reactions" : newBucket.reactions
        ]) { error in
            if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                // Add new Bucket to User's array of bucketsIDs
                Firestore.firestore().collection("users").document(userID).updateData([
                    "bucketIDs" : FieldValue.arrayUnion([newBucket.bucketID])
                ])
                print("Bucket for user \(userID) was created")
            }
        }
    } // End of Create Bucket
    
    
    // MARK: - Delete Bucket
    static func deleteBucket(bucketID: String, completion: @escaping (Bool)-> Void) {
        Firestore.firestore().collection("buckets").document(bucketID).delete() { error in
            if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
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
    
    
    
    
    
    
    
    /*
    static func deleteBucket(bucketID: String, completion: @escaping (Bool)-> Void) {
        Firestore.firestore().collection("buckets").document(bucketID).collection("bucketID").document().delete() { error in
            if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
               completion(true)
                Firestore.firestore().collection("buckets").document(bucketID).collection("commentsID").document().delete() { error in
                    if let error = error {
                         print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    } else {
                       completion(true)
                        Firestore.firestore().collection("buckets").document(bucketID).collection("completion").document().delete() { error in
                            if let error = error {
                                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                            } else {
                               completion(true)
                                Firestore.firestore().collection("buckets").document(bucketID).collection("isPublic").document().delete() { error in
                                    if let error = error {
                                         print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                                    } else {
                                       completion(true)
                                        Firestore.firestore().collection("buckets").document(bucketID).collection("itemsID").document().delete() { error in
                                            if let error = error {
                                                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                                            } else {
                                               completion(true)
                                                Firestore.firestore().collection("buckets").document(bucketID).collection("note").document().delete() { error in
                                                    if let error = error {
                                                         print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                                                    } else {
                                                       completion(true)
                                                        Firestore.firestore().collection("buckets").document(bucketID).collection("reactions").document().delete() { error in
                                                            if let error = error {
                                                                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                                                            } else {
                                                               completion(true)
                                                                Firestore.firestore().collection("buckets").document(bucketID).collection("title").document().delete() { error in
                                                                    if let error = error {
                                                                         print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                                                                    } else {
                                                                       completion(true)
                                                                        Firestore.firestore().collection("buckets").document(bucketID).delete()
                                                                    }
                                                                }
                                                            }
                                                    }
                                            }
                                    }
                            }
                    }
                }
            }
        }
    }
} // End of Class
//.document(bucketID).collection("bucketID").document(bucketID).delete()
                }
            }
        }
    }
}
*/

