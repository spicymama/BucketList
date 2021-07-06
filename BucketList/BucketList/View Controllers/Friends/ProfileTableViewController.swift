//
//  ProfileTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//  Mostly worked on by Josh Hoyle - His problem(s)
//


import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {
    
    // MARK: - Properties
    var refresh: UIRefreshControl = UIRefreshControl()
    static var profileUser: User?
    var currentUser: User?

    //MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentUser()
        updateView()
    } // End of View did load

    
    // MARK: - Functions
    func loadCurrentUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        FirebaseFunctions.fetchUserData(uid: userID) { fetchedUser in
            self.currentUser = fetchedUser
        }
    } // End of Load current user

    func updateView() {
        guard let user: User = ProfileTableViewController.profileUser else { return }
        
        usernameLabel.text = user.username
        // How does this work? How is it handled?
        profilePicImageView.image = user.profilePicture
    }
    
    //MARK: - Actions
    
    // MARK: - Menu Button
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
    
    // MARK: - Menu Button Navigation
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
    
    
    // MARK: - Profile ... Button
    @IBAction func profileDotDotDotBtn(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // The buttons!
        let addFriendButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Add friend Function
            guard let userID = ProfileTableViewController.profileUser?.uid else { return }
            FriendsListModelController.sharedInstance.addFriend(newFriendUserID: userID)
            
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(addFriendButton)
        
        let blockUserButton = UIAlertAction(title: "Messsages", style: .default) { _ in
            self.conversationBtn()
        }
        blockUserButton.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(blockUserButton)
        
        let messageButton = UIAlertAction(title: "Make New Post", style: .default) { _ in
            self.newPostBtn()
        }
        alert.addAction(messageButton)
        
        let reportButton = UIAlertAction(title: "My Profile", style: .default) { _ in
            self.myProfileBtn()
        }
        alert.addAction(reportButton)
        
        let signOutButton = UIAlertAction(title: "Sign Out", style: .default) { _ in
//            signout()
        }
        
        self.present(alert, animated: true, completion: nil)
    } // End of Profile ... button
    
    
    // MARK: - Profile Button Functions

    func blockUserButtonTapped() {
        guard let profileUser = ProfileTableViewController.profileUser else {return}
        FriendsListModelController.sharedInstance.blockUser(profileUID: profileUser.uid)
    } // End of Block user
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        FriendsListModelController.sharedInstance.checkForBlockedUser()
        guard let currentUser = currentUser else {return}
        guard let profileUser = ProfileTableViewController.profileUser else {return}
        ConversationController.shared.createAndSaveConversation(users: [currentUser, profileUser]) { conversation in
            if let conversationListVC = self.storyboard?.instantiateViewController(identifier: "conversationListVC") {
                self.navigationController?.pushViewController(conversationListVC, animated: true)
            }
        }
    } // End of Message Button tapped

    
} // End of Class


// MARK: - Extensions
extension ProfileTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser?.allPictures.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseID, for: indexPath) as! ProfileCollectionViewCell
        
        cell.label.text = currentUser?.username

        return cell
    }
} // End of Extension
