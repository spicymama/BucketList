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
    static var currentUser: User = User()
    static var friendsList: [String] = []
    static var blocked: [String] = []
    static var friendsPosts: [Post] = []
    static var posts: [Post] = []
    var refresh: UIRefreshControl = UIRefreshControl()
    var searchController = UISearchController()
    var dataSource: [Post] = []
    var resultSearchController: UISearchController? = nil
    
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        fetchPosts()
        
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
        view.backgroundColor = .lightGray
        self.tableView.rowHeight = 650
    
    }
    
    // MARK: - Actions
    @IBAction func segmentWasChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            dataSource = FeedTableViewController.friendsPosts
            
            view.backgroundColor = .gray
            tableView.backgroundColor = .lightGray
            tableView.reloadData()
        }
        else if sender.selectedSegmentIndex == 1 {
            dataSource = FeedTableViewController.posts
            
            view.backgroundColor = .blue
            tableView.backgroundColor = .systemBlue
            tableView.reloadData()
        }
    }
    
    // MARK: - Functions
    func fetchPosts() {
        FirebaseFunctions.fetchCurrentUser { result in
            switch result {
            case true:
                FirebaseFunctions.fetchFriendz(uid: FeedTableViewController.currentUser.uid) { result in
                    switch result {
                    case true:
                        FirebaseFunctions.fetchAllPosts { result in
                            self.dataSource = FeedTableViewController.friendsPosts
                            print(FeedTableViewController.friendsList)
                            print(FeedTableViewController.blocked)
                            self.setupViews()
                            self.loadData()
                        }
                    case false:
                        print("error fetching posts")
                    }
                }
            case false:
                print("error fetching current user")
            }
            self.updateViews()
        }
    }
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to see new Posts")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    @objc func loadData() {
        self.updateViews()
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
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? FeedTableViewCell
        let post = dataSource[indexPath.row]
        cell?.post = post
        
        return cell ?? UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostViewController else { return }
        
        let post: Post = dataSource[indexPath.row]
        let postID = post.postID
        // let userID: String = post.creatorID
        ProfileTableViewCell.post = post
        PostViewController.currentPost = post
        
        vc.postID = postID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Alert Action
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
