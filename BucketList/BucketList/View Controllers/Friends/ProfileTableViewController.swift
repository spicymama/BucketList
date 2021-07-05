//
//  ProfileTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//
import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {
    static let shared = ProfileTableViewController()
    var refresh: UIRefreshControl = UIRefreshControl()
    let db = Firestore.firestore()
    var currentUser: User?
    var profileUser: User?
    
    //MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
   
    //MARK: - Actions
    
    @IBAction func detailsButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // The buttons!
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelBtn)
        
        let messageBtn = UIAlertAction(title: "Messsage", style: .default) { _ in
            self.messageBtn()
        }
        alert.addAction(messageBtn)
        
        let addFriendBtn = UIAlertAction(title: "Add Friend", style: .default) { _ in
            self.addFriendButton()
        }
        alert.addAction(addFriendBtn)
        
        let reportBtn = UIAlertAction(title: "Report", style: .default) { _ in
            self.reportBtn()
        }
        alert.addAction(reportBtn)
        
        let blockBtn = UIAlertAction(title: "Block", style: .default) { _ in
            self.blockBtn()
        }
        alert.addAction(blockBtn)
        
        self.present(alert, animated: true, completion: nil)
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
        
        let messageBtn = UIAlertAction(title: "Messsage", style: .default) { _ in
            self.messageBtn()
        }
        alert.addAction(messageBtn)
        
        let addFriendBtn = UIAlertAction(title: "Add Friend", style: .default) { _ in
            self.addFriendButton()
        }
        alert.addAction(addFriendBtn)
        
        let reportBtn = UIAlertAction(title: "Report", style: .default) { _ in
            self.reportBtn()
        }
        alert.addAction(reportBtn)
        
        let blockBtn = UIAlertAction(title: "Block", style: .default) { _ in
            self.blockBtn()
        }
        alert.addAction(blockBtn)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    func messageBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "conversationListVC")
        self.navigationController?.pushViewController(vs, animated: true)
        }
    
    func addFriendButton() {
        FriendsListModelController.sharedInstance.addFriend()
        print("Added new friend (good thing too cuz you need them)")
    }
    
    func reportBtn() {
        print("We will review this report probably")
    }

    func blockBtn() {
        guard let profileUser = profileUser else {return}
        FriendsListModelController.sharedInstance.blockUser(profileUID: profileUser.uid)
        print("Blocked that nasty user")
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

/*
 
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
 */
