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
    
    
    
    static var currentUser: User = User()
    static var friendsList: [String] = []
    static var blocked: [String] = []
    static var friendsPosts: [Post] = []
    static var posts: [Post] = []
    var refresh: UIRefreshControl = UIRefreshControl()
    var searchController = UISearchController()
    var dataSource: [Post] = []
    var resultSearchController: UISearchController? = nil
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
    // MARK: - Navigation
    @IBAction func conversationBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "conversationListVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    
    @IBAction func newPostBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "gavinPost", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "newPostVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }

    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostViewController else { return }
        
        let post = dataSource[indexPath.row]
        let commentsID = post.commentsID
       // let userID: String = post.creatorID
        ProfileTableViewCell.post = post
        PostViewController.currentPost = post
        
        vc.commentsID = commentsID
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ProfileTableViewController else {return}
            let post = dataSource[indexPath.row]
            let userID = post.creatorID
            ProfileTableViewCell.post = post
            
            destinationVC.profileUserID = userID
        }
        }
 */
    }
// End of Class
