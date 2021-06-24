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
       
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
        func updateViews(){
            guard let user = user else {return}
            profilePic.image = UIImage(named: "swing")
            usernameLabel.text = user.username
            achievementLabel.text = user.lastName
            imageView1.image = UIImage(named: "gorgeousGirlfriend")
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
