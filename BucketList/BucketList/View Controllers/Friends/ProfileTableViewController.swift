//
//  ProfileTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 1400
       
    }
    var currentUser: User?
    var user: String? {
        didSet {
            
            loadViewIfNeeded()
        }
    }
    
    func updateView() {
        FirebaseFunctions.fetchUsersData { (result) in
            let users: [User] = result
            for i in users {
                if i.uid == self.user {
                    self.currentUser = i
                }
            }
        }
    }
   
  
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell
        
        cell?.currentUser = currentUser

        return cell ?? UITableViewCell()
    }
    

    
    // MARK: - Navigation

   
   

}
extension ProfileTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser?.allPictures.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseID, for: indexPath) as! ProfileCollectionViewCell
        
        cell.label.text = currentUser?.username
        cell.layer.borderWidth = Constants.borderWidth
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = .orange
        
        return cell
    }
}

// MARK: - Constants

private enum Constants {
    static let spacing: CGFloat = 16
    static let borderWidth: CGFloat = 0.5
    static let reuseID = "CollectionCell"
}
