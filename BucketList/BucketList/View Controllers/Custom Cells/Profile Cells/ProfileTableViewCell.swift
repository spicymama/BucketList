//
//  ProfileTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit


class ProfileTableViewCell: UITableViewCell {

    static let shared = ProfileTableViewCell()
    static var post: Post?
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
        }
       
    var user: User? {
        didSet {
            updateViews()
            
        }
    }
    
        func updateViews(){
            guard let user = user else {return}
            BucketFirebaseFunctions.fetchBuckets { result in
                self.buckitz = result
                print(self.buckitz)
            }
            profilePic.image = UIImage(named: "swing")
            usernameLabel.text = user.username
            achievementLabel.text = user.lastName
            imageView1.image = UIImage(named: "lift")
            collectionView.contentSize = CGSize(width: 2000, height: 100)
            collectionView.addSubview(UIImageView())
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

