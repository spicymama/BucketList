//
//  BucketsPostsViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 8/10/21.
//

import UIKit

class BucketsPostsTableViewController: UITableViewController {

    // MARK: - Properties
    static var bucket: Bucket?
    var posts: [Post] = []
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Posts for: " + BucketsPostsTableViewController.bucket!.title
        
        fetchData()
    } // End of View did load
    
    
    // MARK: - Functions
    func fetchData() {
        guard let bucketID = BucketsPostsTableViewController.bucket?.bucketID else { return }
        FirebaseFunctions.fetchAllPostsForBucket(bucketID: bucketID) { FetchedPosts in
            self.posts = FetchedPosts
            
            self.tableView.reloadData()
        }
    } // End of Fetch Data
    

    // MARK: - Table Data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? BucketPostsTableViewCell
        let post = posts[indexPath.row]
        cell?.post = post
        
        return cell ?? UITableViewCell()
    } // End of Cell for row at
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "postDetailVC") as? PostViewController else { return }
        let post = posts[indexPath.row]
        
        PostViewController.currentPost = post
        navigationController?.pushViewController(vc, animated: true)
    } // End of did select row
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if posts[indexPath.row].imageURL != "" {
            return 424
        } else {
            return 32
        }
    } // End of Height for row atw
    
} // End of Class
