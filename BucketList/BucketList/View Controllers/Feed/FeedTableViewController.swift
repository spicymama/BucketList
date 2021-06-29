//
//  TableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class FeedTableViewController: UITableViewController {
    static var currentUser: User = User()
    static var friendsList: [String] = []
    static var blocked: [String] = []
    static var friendsPosts: [Post] = []
    static var posts: [Post] = []
    var refresh: UIRefreshControl = UIRefreshControl()
    var searchController = UISearchController()
    var dataSource: [Post] = []
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        navigationItem.searchController = searchController
        
        super.viewDidLoad()
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
        let vs = storyBoard.instantiateViewController(withIdentifier: "ConversationListVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    
    @IBAction func newPostBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "gavinPost", bundle: nil)
        let vs = storyBoard.instantiateViewController(withIdentifier: "newPostVC")
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ProfileTableViewController else {return}
            let post = dataSource[indexPath.row]
            let userID = post.creatorID
            ProfileTableViewCell.post = post
            
            destinationVC.profileUserID = userID
        }
    }
} // End of Class


