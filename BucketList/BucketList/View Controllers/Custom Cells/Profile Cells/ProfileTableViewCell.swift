//
//  ProfileTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit
import Firebase
import FirebaseStorage


class ProfileTableViewCell: UITableViewCell {

    private let storage = Storage.storage().reference()
    static let shared = ProfileTableViewCell()
    static var post: Post?
    //var currentUser: String?
    var user: User?
    var buckitz: [Bucket] = []
    
        @IBOutlet weak var profilePic: UIImageView!
        @IBOutlet weak var usernameLabel: UILabel!
        @IBOutlet weak var publicListTableView: UITableView!
        @IBOutlet weak var imageView1: UIImageView!
        @IBOutlet weak var achievementLabel: UILabel!
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var lilTableView: UITableView!
    
        var strings = ["Climb Mountain", "Go to Disneyland", "Fly in a small plane", "see a whale", "Hug a panda"]
        
        override func awakeFromNib() {
            super.awakeFromNib()
            lilTableView.delegate = self
            lilTableView.dataSource = self
            collectionView.delegate = self
            collectionView.dataSource = self
            updateViews()
        }
 
    func updateViews(){
        BucketFirebaseFunctions.fetchBuckets { result in
                self.buckitz = result
                print(self.buckitz)
            }
       /*
        fetchProfilePic(pictureURL: user?.profilePicUrl ?? "") { result in
                self.profilePic.image = result
            }
 */
            usernameLabel.text = user?.username
            collectionView.contentSize = CGSize(width: 2000, height: 100)
            collectionView.addSubview(UIImageView())
        }
    
    func fetchProfilePic(pictureURL: String, completion: @escaping (UIImage) -> Void){
        guard let url = URL(string: pictureURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { 📀, _, 🛑 in
            guard let 📀 = 📀, 🛑 == nil else {
                print("Error in \(#function)\(#line)")
                return
            }
            DispatchQueue.main.async {
                guard let image = UIImage(data: 📀) else {return}
               self.profilePic.image = image
               completion(image)
            } // End of Dispatch Queue
        })
        task.resume()
        
      //  updateViews()
    }
}
    extension ProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
            let text = "Recent Accomplishment..."
            cell.text = text
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = frame.width * 0.75
            return CGSize(width: width, height: 120)
        }
        
        
}

extension ProfileTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, numberOfRowsInSection section: Int) -> Int {
        buckitz.count
    }
    
    func tableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentPostCell", for: indexPath) as? RecentPostsTableViewCell else {return UITableViewCell()}
        let string = buckitz[indexPath.row].title
    cell.string = string
    return cell
}
    }

