//
//  ProfileTableViewCell.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    static let shared = ProfileTableViewCell()
        @IBOutlet weak var profilePic: UIImageView!
        @IBOutlet weak var usernameLabel: UILabel!
        @IBOutlet weak var publicListTableView: UITableView!
        @IBOutlet weak var imageView1: UIImageView!
        @IBOutlet weak var achievementLabel: UILabel!
        @IBOutlet weak var collectionView: UICollectionView!
        
        var strings = ["Climb Mountain", "Go to Disneyland", "Fly in a small plane", "see a whale"]
        
        override func awakeFromNib() {
            super.awakeFromNib()
            collectionView.delegate = self
            collectionView.dataSource = self
        }
       
        
        
        var currentUser: User? {
            didSet {
                updateViews()
            }
        }
         var count = 0
     
        func updateViews(){
            profilePic.image = currentUser?.profilePicture
            usernameLabel.text = currentUser?.firstName
            imageView1.image = currentUser?.allPictures[0]
            collectionView.contentSize = CGSize(width: 2000, height: 100)
            collectionView.addSubview(UIImageView())
            print(currentUser?.firstName)
            print(currentUser?.lastName)
            
            
        }
    }

    extension ProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? ProfileCollectionViewCell else {return UICollectionViewCell()}
            let text = "Recent Accomplishment..."
                //UserController.shared.users[indexPath.row].acheivements[indexPath.row]
            cell.text = text
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = frame.width * 0.75
            return CGSize(width: width, height: 120)
        }
        
        
}
