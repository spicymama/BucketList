//
//  ProfileTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

/*
import UIKit
import Firebase
import FirebaseStorage


class OldProfileTableViewCell: UITableViewCell {
    
    private let storage = Storage.storage().reference()
    static let shared = ProfileTableViewCell()
    static var post: Post?
    var postArr: [Post] = []
    var currentUser: String?
    static var user: User?
    var buckitz: [Bucket] = []

    
    @IBOutlet weak var lilTableView: UITableView!
    
    var strings = ["Climb Mountain", "Go to Disneyland", "Fly in a small plane", "see a whale", "Hug a panda"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lilTableView.delegate = self
        lilTableView.dataSource = self
        
        updateViews()
    }
    
    func updateViews(){
        BucketFirebaseFunctions.fetchBuckets { result in
            self.buckitz = result
            self.lilTableView.reloadData()
        }
//        collectionView.contentSize = CGSize(width: 2000, height: 100)
//        collectionView.addSubview(UIImageView())
    } // End of Func Update View
    
} // End of Class Profile Table View Cell


// MARK: - Extensions
extension ProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedTableViewController.shared.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
        let text = FeedTableViewController.shared.dataSource[indexPath.row].note
        cell.text = text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width * 0.75
        return CGSize(width: width, height: 120)
    }
    
    
} // End of Extension

extension ProfileTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, numberOfRowsInSection section: Int) -> Int {
        buckitz.count
    }
    
    func tableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        let string = buckitz[indexPath.row].title
        print(string)
        cell.textLabel?.text = string
        return cell
    }
} // End of Extension

*/
