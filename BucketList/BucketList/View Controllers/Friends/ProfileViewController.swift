//
//  ProfileTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//  Heavily messed up by Ethan Andersen on 7/6/21.
//  Josh worked really hard on it too
//  Really lost on what Justin did
//  Maybe that's why nothing seemed to be working? Or was it working...
//
//
//  Totally rebuilt by Ethan Andersen on 7/6/21
//
//


import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicBtn: UIButton!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    static let shared = ProfileViewController()
    var refresh: UIRefreshControl = UIRefreshControl()
    static var profileUser: User?
    static var profileUserIsLoggedInUser: Bool?
    var loggedInUser: User?
    
    var posts: [Post] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLoggedInUser()
        fetchPosts()

        tableView.delegate = self
        tableView.dataSource = self
        
        updateView()
    } // End of view did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    } // End of View will appear
    
    // MARK: - Actions
    @IBAction func profilePicBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    } // End of Profile Pic button
    
    
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
            conversationBtn()
        }
        alert.addAction(conversationBtn)
        
        let newPostBtn = UIAlertAction(title: "Make New Post", style: .default) { _ in
            newPostBtn()
        }
        alert.addAction(newPostBtn)
        
        let bucketBtn = UIAlertAction(title: "My Buckets", style: .default) { _ in
            newBucketBtn()
        }
        alert.addAction(bucketBtn)
        
        let signOutBtn = UIAlertAction(title: "Sign Out", style: .default) { _ in
            signOutBtn()
        }
        alert.addAction(signOutBtn)
        
        let myFriendsListBtn = UIAlertAction(title: "My Friends", style: .default) { _ in
            myFriendsListBtn()
        }
        alert.addAction(myFriendsListBtn)
        
        self.present(alert, animated: true, completion: nil)
        
        func conversationBtn() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "conversationListVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func newPostBtn() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "NewPost", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "newPostVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func newBucketBtn() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "NewBucket", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "BucketListTableVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }

        func signOutBtn() {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let ???? as NSError {
                print("Error signing out: %@", ????)
            }
            navigationController?.popToRootViewController(animated: true)
        } // End of Sign out Button
        
        func myFriendsListBtn() {
            
        } // End of Friends List Button
        
    } // End of Menu Button
    
    
    // MARK: - Dot dot dot Button
    @IBAction func dotDotDotBtn(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // The buttons!
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        cancelBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelBtn)
        
        let messageBtn = UIAlertAction(title: "Messsage", style: .default) { _ in
            messageBtn()
        }
        alert.addAction(messageBtn)
        
        let addFriendBtn = UIAlertAction(title: "Add Friend", style: .default) { _ in
            addFriendButton()
        }
        alert.addAction(addFriendBtn)
        
        let reportBtn = UIAlertAction(title: "Report", style: .default) { _ in
            reportBtn()
        }
        alert.addAction(reportBtn)
        
        let blockBtn = UIAlertAction(title: "Block", style: .default) { _ in
            blockBtn()
        }
        alert.addAction(blockBtn)
        
        self.present(alert, animated: true, completion: nil)
        
        func messageBtn() {
            let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
            let vs = storyBoard.instantiateViewController(withIdentifier: "conversationListVC")
            self.navigationController?.pushViewController(vs, animated: true)
            }
        
        func addFriendButton() {
            guard let profileUserID = ProfileViewController.profileUser?.uid else { return }
            FriendsListModelController.sharedInstance.addFriend(newFriendUserID: profileUserID)
            print("Added new friend (good thing too cuz you need them)")
        }
        
        func reportBtn() {
            print("We will review this report probably")
        }

        func blockBtn() {
            guard let profileUserID = ProfileViewController.profileUser?.uid else { return }
            FriendsListModelController.sharedInstance.blockUser(profileUID: profileUserID)
            print("Blocked that nasty user")
        }
    } // End of Dot dot dot button
    
    
    // MARK: - Functions
    func fetchLoggedInUser() {
        FirebaseFunctions.fetchCurrentUserData { FetchedUser in
            self.loggedInUser = FetchedUser
        }
    } // End of Func fetche logged in user
    
    func updateView() {
        guard let profileUser = ProfileViewController.profileUser else { return }
        
        usernameLabel.text = ("~" + profileUser.username)
        updateProfilePicture(profileUser: profileUser)
        
        tableView.reloadData()
    } // End of Func update view
    
    
    func updateProfilePicture(profileUser: User) {
        FirebaseFunctions.fetchProfileImage(user: profileUser) { fetchedProfileImage in
            self.profilePicImageView.image = fetchedProfileImage
        }
        
        if profileUser.uid == loggedInUser?.uid {
            // Show pick photo thing
            self.profilePicBtn.isHidden = false
        } else {
            // Hide pick photo thing
            self.profilePicBtn.isHidden = true
        }
    } // End of Update profile Picture
    
    
    // MARK: - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        
        let storage = Storage.storage().reference()
        guard let user = Auth.auth().currentUser else {return}
        
        let ref = storage.child("images/\(user.uid).profilePic.png")
        ref.putData(imageData, metadata: nil, completion: { _, ???? in
            if let ???? = ???? {
                print("Error in \(#function)\(#line) : \(????.localizedDescription) \n---\n \(????)")
                return
            }
            ref.downloadURL(completion: { url, ???? in
                if let ???? = ???? {
                    print("Error in \(#function)\(#line) : \(????.localizedDescription) \n---\n \(????)")
                }
                guard let urlString = url?.absoluteString else {return}
                UserDefaults.standard.set(urlString, forKey: "url")
                let documentref = Firestore.firestore().collection("users").document(user.uid)
                
                documentref.updateData(["profilePicUrl" : urlString]) { error in
                    if let error = error {
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            })
        })
    } // End of Image picker Function
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    } // End of Function
    
    func fetchPosts() {
        FirebaseFunctions.fetchAllPostsForUser(userID: ProfileViewController.profileUser!.uid) { UsersPosts in
            self.posts = UsersPosts
            self.tableView.reloadData()
        }
        // Might need an update View here
    } // End of Fetch posts
    
} // End of Profile Table View Controller


// MARK: - Extensions
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    } // End of Row count
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilePostCell", for: indexPath) as? ProfileTableViewCell
        let post = posts[indexPath.row]
        
        cell?.post = post
        
        return cell ?? UITableViewCell()
    } // End of Cell for row at
 
    
    // Did select row at
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostViewController else { return }
        
        let post = posts[indexPath.row]
        let commentsID = post.commentsID
        let userID: String = post.authorID
       
        PostViewController.currentPost = post
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
} // End of Extensino
