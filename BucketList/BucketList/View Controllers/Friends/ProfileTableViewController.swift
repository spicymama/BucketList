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
    var profileUser: User?
    
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
        guard let profileUser = profileUser else {return}
        FriendsListModelController.sharedInstance.blockUser(profileUID: profileUser.uid)
    }
    @IBAction func messageButtonTapped(_ sender: Any) {
        FriendsListModelController.sharedInstance.checkForBlockedUser()
        guard let currentUser = currentUser else {return}
        guard let profileUser = profileUser else {return}
        ConversationController.shared.createAndSaveConversation(users: [currentUser, profileUser]) { conversation in
            if let conversationListVC = self.storyboard?.instantiateViewController(identifier: "conversationListVC") {
                self.navigationController?.pushViewController(conversationListVC, animated: true)
            }
        }
            
    
    }
    @IBAction func bucketListButtonTapped(_ sender: Any) {
        if let bucketList = self.storyboard?.instantiateViewController(identifier: "BucketListTableVC") {
            self.navigationController?.pushViewController(bucketList, animated: true)
        }
    }

    @IBAction func friendsListButtonTapped(_ sender: Any) {
        if let friendsList = self.storyboard?.instantiateViewController(identifier: "friendsListVC") {
          self.navigationController?.pushViewController(friendsList, animated: true)
        }
    }
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 1400
//        fetchUser()
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

     /*
    func fetchUser() {
        FirebaseFunctions.fetchUserData(uid: profileUserID ?? "" ) { (result) in
            self.currentUser = result
//            self.updateViews()
        }
    }
    */
    
    
   // var users: [User] = []
        @objc func loadData() {
                self.updateViews()
    }
  
    var user: String? {
        didSet {
            loadViewIfNeeded()
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
    @IBAction func menuBtn(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // The buttons!
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelBtn)
        
        let conversationBtn = UIAlertAction(title: "Messsages", style: .default) { _ in
            self.conversationBtn()
        }
        alert.addAction(conversationBtn)
        
        let newPostBtn = UIAlertAction(title: "Make New Post", style: .default) { _ in
            self.newPostBtn()
        }
        alert.addAction(newPostBtn)
        
        let bucketBtn = UIAlertAction(title: "My Buckets", style: .default) { _ in
            self.newBucketBtn()
        }
        alert.addAction(bucketBtn)
        
        let profileBtn = UIAlertAction(title: "My Profile", style: .default) { _ in
            self.myProfileBtn()
        }
        alert.addAction(profileBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    func conversationBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "conversationListVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    func newPostBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "newPostVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    func newBucketBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewBucket", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "BucketListTableVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }

    func myProfileBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "profileDetailVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
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


 
// MARK: - Constants
private enum Constants {
    static let spacing: CGFloat = 16
    static let borderWidth: CGFloat = 0.5
    static let reuseID = "collectionCell"
}

