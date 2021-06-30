//
//  PostDetailTableViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/30/21.
//

import UIKit

class PostDetailTableViewController: UIViewController {

    
    // MARK: - Properties
    var profileUserID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func profileDetailBtn(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ProfileDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileDetailVC")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
} // End of Class


// MARK: - Extensions
extension PostDetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }

} // End of Extension
