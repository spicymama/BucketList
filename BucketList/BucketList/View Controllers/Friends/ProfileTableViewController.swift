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
    let db = Firestore.firestore()
    var currentUser: User?
    var profileUserID: String = ""
    
    //MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var blockUserButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var bucketListButton: UIButton!
    @IBOutlet weak var friendsListButton: UIButton!
    
    //MARK: - Actions
    
    @IBAction func addFriendButtonTapped(_ sender: Any) {
        FriendsListModelController.sharedInstance.addFriend()
    }
    @IBAction func blockUserButtonTapped(_ sender: Any) {
//        FriendsListModelController.sharedInstance.blockUser(profileUID: profileUserID)
    }
    @IBAction func messageButtonTapped(_ sender: Any) {
        //FriendsListModelController.sharedInstance.blockUser(uidtoblock: <#T##String#>)
        //open justin's create message view/open existing message view.
    }
    @IBAction func bucketListButtonTapped(_ sender: Any) {
       // if let bucketlist = self.storyboard?.instantiateInitialViewController(identifier: "bucketlistVC") {
       //     self.navigationController?.pushViewController(bucketlist, animated: true)
     //   }
    }

    @IBAction func friendsListButtonTapped(_ sender: Any) {
      //  if let friendsList = self.storyboard?.instantiateViewController(identifier: "friendsListVC") {
        //    self.navigationController?.pushViewController(friendsList, animated: true)
      //  }
    }
    
    
    
 
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
        FirebaseFunctions.fetchUserData(uid: profileUserID ?? "" ) { (result) in
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
//        cell.user = user
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

/*
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

*/
 
// MARK: - Constants
private enum Constants {
    static let spacing: CGFloat = 16
    static let borderWidth: CGFloat = 0.5
    static let reuseID = "CollectionCell"
}

