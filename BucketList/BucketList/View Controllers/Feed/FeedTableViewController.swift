//
//  TableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 6/21/21.
//

import UIKit

class FeedTableViewController: UITableViewController {
    var refresh: UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        view.backgroundColor = .lightGray
        self.tableView.rowHeight = 650
        
    }
    
    @IBAction func segmentWasChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            view.backgroundColor = .gray
            tableView.backgroundColor = .lightGray
            tableView.reloadData()
        }
        else if sender.selectedSegmentIndex == 1 {
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
    
    var posts: [Post] = []
    
    @objc func loadData() {
        FirebaseFunctions.fetchAllPosts { (result) in
            self.posts = result
            self.updateViews()
        }
    }
    
    func sendUser() {
        
    }
    //static var user = User()
   
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? FeedTableViewCell
        let post = posts[indexPath.row]
        cell?.post = post
       
        
        
        return cell ?? UITableViewCell()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ProfileTableViewController else {return}
            
            let post = posts[indexPath.row]
            let userID = post.creatorID
            
           destinationVC.userID = userID
        }
    }
}



