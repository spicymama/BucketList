//
//  BucketFirebaseFunctions.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/29/21.
//

import Foundation
import Firebase

class BucketFirebaseFunctions {
    

static func fetchBuckets(completion: @escaping ([Bucket])-> Void) {
    
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
                    let title = data["title"] as! String
                    let bucketID = data["bucketID"] as! String
                    let isPublic = data["isPublic"] as! Bool
                    let note = data["note"] as! String
                    let commentsID = data["commentsID"] as! String
                    let itemsID = data["itemsID"] as! String
                    let completion = data["completion"] as! Int
                    let reactions = data["reactions"] as! [String]
                    
                    let bucket = Bucket(title: title, note: note, commentsID: commentsID, itemsID: itemsID, bucketID: bucketID, completion: completion, reactions: reactions, isPublic: isPublic)
                    bucketData.append(bucket)
                    BucketListTableViewController.bucketList.append(bucket)
                    group.leave()
                }
            }
            group.notify(queue: DispatchQueue.main) {
                completion(bucketData)
            }
        }
    }
}
static func fetchBucket(bucketID: String, completion: @escaping ([String : Any])-> Void) {
    let bucketID = bucketID
    let bucketData = Firestore.firestore().collection("buckets").document(bucketID)
    bucketData.getDocument { document, error in
        if let error = error {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        } else {
            completion(document!.data()!)
            
        }
    }
}
    
    static func createBucket(title: String, bucketID: String = UUID().uuidString, completion: Int = 0, isPublic: Bool = true, itemsID: String, note: String, commentsID: String, reactions: [String] = []) {
        
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("buckets").document(bucketID).setData([
            "bucketID" : bucketID,
            "completion" : completion,
            "title" : title,
            "isPublic" : isPublic,
            "itemsID" : itemsID,
            "note" : note,
            "commentsID" : commentsID,
            "reactions" : reactions
        ]) { error in
            if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                print("Bucket for user \(uid ?? "") was created")
            }
        }
        
    }
} // End of Class

