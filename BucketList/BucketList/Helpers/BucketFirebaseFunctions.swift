//
//  BucketFirebaseFunctions.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/29/21.
//

import Foundation
import Firebase

class BucketFirebaseFunctions {
    

static func fetchBuckets(completion: @escaping ([List])-> Void) {
    
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
            
            var bucketData: [List] = []
            for i in bucketIDs {
                group.enter()
                BucketFirebaseFunctions.fetchBucket(bucketID: i) { data in
                    let title = data["title"]
                    let items = data["items"]
                    
                    let bucket = List(title: title as! String, list: items as? [String] ?? ["A", "b"])
                    bucketData.append(bucket)
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
            /*
             guard let document = document else {return}
             
             let title = document.data()!["title"]
             let list = document.data()!["items"]
             let list1: List = List(title: title as! String, list: list as! [String])
             */
            completion(document!.data()!)
            
        }
    }
}
    
    static func createBucket(title: String, bucketID: String = UUID().uuidString, completed: Bool = false, isPublic: Bool, items: [String], note: String) {
        
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("buckets").document(bucketID).setData([
            "bucketID" : bucketID,
            "completed" : completed,
            "title" : title,
            "isPublic" : isPublic,
            "items" : items,
            "note" : note
        ]) { error in
            if let error = error {
                 print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            } else {
                print("Bucket for user \(uid ?? "") was created")
            }
        }
        
    }
} // End of Class

