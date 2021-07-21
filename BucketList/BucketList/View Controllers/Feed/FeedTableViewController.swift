//
//  TableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class FeedTableViewController: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // MARK: - Properties
    static let shared = FeedTableViewController()
    static var currentUser: User = User()
    static var friendsList: [String] = []
    static var blocked: [String] = []
    var friendsPosts: [Post] = []
    var popularPosts: [Post] = []
    var dataSource: [Post] = []
    var refresh: UIRefreshControl = UIRefreshControl()
    var searchController = UISearchController()
    var resultSearchController: UISearchController? = nil
    
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Can't return to login screen
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        checkSegmentIndex()
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        let storyboard: UIStoryboard = UIStoryboard(name: "SearchBar", bundle: nil)
        let userSearchTable = storyboard.instantiateViewController(identifier: "userSearchTable") as! SearchUserTableViewController
        resultSearchController = UISearchController(searchResultsController: userSearchTable)
        resultSearchController?.searchResultsUpdater = userSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Who are we looking for?"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        view.backgroundColor = GlobalFunctions.hexStringToUIColor(hex: "#d3d3d3")
        tableView.rowHeight = 650
        
        checkForFriendsPosts()
        
        tableView.reloadData()
    } // End of View Did load
    
    // MARK: - Actions
    @IBAction func segmentWasChanged(_ sender: UISegmentedControl) {
        dataSource = []
        checkForFriendsPosts()
        checkSegmentIndex()
    } // End of Segment was changed
    
    // MARK: - Functions
    func checkSegmentIndex() {
        if segmentedController.selectedSegmentIndex == 0 {
            if friendsPosts == [] {
            self.fetchFriendsPosts()
                self.view.backgroundColor = .gray
                self.tableView.backgroundColor = .lightGray
                self.updateViews()
            } else {
                self.dataSource = self.friendsPosts
                self.view.backgroundColor = .gray
                self.tableView.backgroundColor = GlobalFunctions.hexStringToUIColor(hex: "#d3d3d3")
                self.updateViews()
            }
        }
        else if segmentedController.selectedSegmentIndex == 1 {
            if popularPosts == [] {
            self.fetchPopularPosts()
                self.updateViews()
            } else {
                self.dataSource = self.popularPosts
                self.tableView.backgroundColor = GlobalFunctions.hexStringToUIColor(hex: "#8cdffe")
                self.updateViews()
            }
        }
    } // End of Setup post fetching
    
    func fetchPopularPosts() {
        FirebaseFunctions.fetchAllPosts { fetchedAllPosts in
            self.popularPosts = []

            if fetchedAllPosts.count > 0 {
                self.popularPosts.append(contentsOf: fetchedAllPosts)
                
                self.dataSource = self.popularPosts
                
                self.tableView.reloadData()
            }
            self.tableView.backgroundColor = GlobalFunctions.hexStringToUIColor(hex: "#8cdffe")
            self.updateViews()
        }
    } // End of Func fetch Popular Posts
    
    func fetchFriendsPosts() {
        FirebaseFunctions.fetchCurrentUser { fetchedUser in
            let friendsListID: String = fetchedUser.friendsListID!
            
            FirebaseFunctions.fetchFriends(friendsListID: friendsListID) { fetchedFriendsList in
                let friendsIDs: [String] = fetchedFriendsList.friends
                                
                for friendID in friendsIDs {
                    FirebaseFunctions.fetchAllPostsForUser(userID: friendID) { fetchedFriendsPosts in
                        self.friendsPosts.append(contentsOf: fetchedFriendsPosts)
    
                        self.dataSource = self.friendsPosts
                        self.friendsPosts = []
                        self.view.backgroundColor = .gray
                        self.tableView.backgroundColor = .lightGray
                        
                        self.tableView.reloadData()
                    } // End of Fetch all posts for users
                } // End of Friend id in friends id loop
            } // End of Fetch Friends
        } // End of Fetch Current User
    } // End of Fetch Post
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refresh)
        self.tableView.reloadData()
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    @objc func loadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    func updateSearchController() {
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        let userSearchTable = storyboard!.instantiateViewController(identifier: "userSearchTable") as! SearchUserTableViewController
        resultSearchController = UISearchController(searchResultsController: userSearchTable)
        resultSearchController?.searchResultsUpdater = userSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Who are we looking for?"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        self.tableView.reloadData()
    }
   
    func checkForFriendsPosts() {
        if segmentedController.selectedSegmentIndex == 0 {
            if friendsPosts.count == 0 {
                let alert = UIAlertController(title: "Looks like you don't have any friends!", message: nil, preferredStyle: .alert)
                let alertButton = UIAlertAction(title: "Lets change that!", style: .default)
                alert.addAction(alertButton)
                
                present(alert, animated: true, completion: nil)
                self.resultSearchController?.searchBar.placeholder = "Lets find some new friends!"
            } else {
                return
            }
        } else if self.segmentedController.selectedSegmentIndex == 1 {
            self.resultSearchController?.searchBar.placeholder = "Who are we looking for?"
        }
    } // End of Func no friends
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? FeedTableViewCell
            let post = dataSource[indexPath.row]
            cell?.post = post
        
        return cell ?? UITableViewCell()
    } // End of Cell for row at
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostViewController else { return }
        let post = dataSource[indexPath.row]
        
        PostViewController.currentPost = post
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = dataSource[indexPath.row].imageURL ?? ""
        let title = dataSource[indexPath.row].bucketTitle ?? ""
        var imageHeight = CGFloat(600)
        
        if image == "" {
            imageHeight = imageHeight - 380
        }
        
        if title == "" {
            imageHeight = imageHeight - 64
        }
        
        self.tableView.rowHeight = imageHeight
        
        return self.tableView.rowHeight
    } // End of Height for row at
    
    
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
        
        let myFriendsListBtn = UIAlertAction(title: "My Friends", style: .default) { _ in
            self.myFriendsListBtn()
        }
        alert.addAction(myFriendsListBtn)
        
        self.present(alert, animated: true, completion: nil)
    }

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
    
    func myProfileBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
       guard let vc = storyBoard.instantiateViewController(withIdentifier: "profileDetailVC") as? ProfileViewController else {return}
        
        FirebaseFunctions.fetchCurrentUserData { fetchedUser in
            vc.profileUser = fetchedUser
            self.navigationController?.pushViewController(vc, animated: true)
        }
    } // End of My Profile Button
    
    func myFriendsListBtn() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "conversationCreationVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // End of Menu Button
    
} // End of Class
