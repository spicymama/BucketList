//
//  ProfileTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//
import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {
    var refresh: UIRefreshControl = UIRefreshControl()
    var userID: String?
    var currentUser: User?
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 1400
        fetchUser()
       setupViews()
        loadData()

    }
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    func updateViews() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }

     
    func fetchUser() {
        FirebaseFunctions.fetchUserData(uid: userID ?? "" ) { (result) in
            self.currentUser = result
            self.updateViews()
        }
    }
    
    
    
   // var users: [User] = []
        @objc func loadData() {
                self.updateViews()
    }
  
    var user: String? {
        didSet {
            
            loadViewIfNeeded()
        }
    }
    
    func updateView() {
        FirebaseFunctions.fetchUsersData(passedUserIDs: []) { (result) in
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
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileTableViewCell else {return UITableViewCell()}
        if let user = currentUser {
        cell.user = user
        }
        return cell
    }
    

    
    // MARK: - Navigation
    @IBAction func conversationBtn(_ sender: Any) {
        // Go to ConversationMessageViewController
        let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "ConversationListVC")
        self.navigationController?.pushViewController(vs, animated: true)
    } // End of Conversation Button
    
   

} // End of Class


// MARK: - Extensions
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

extension ProfileTableViewController {
    func lilTableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func lilTableView(_ tableView: UITableView = ProfileTableViewCell.shared.lilTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "recentPostCell", for: indexPath) as? ProfileTableViewCell else {return UITableViewCell()}
        if let user = currentUser {
        cell.user = user
        }
        return cell
    }
}

// MARK: - Constants
private enum Constants {
    static let spacing: CGFloat = 16
    static let borderWidth: CGFloat = 0.5
    static let reuseID = "CollectionCell"
}

