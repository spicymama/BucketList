//
//  BucketItemTableViewController.swift
//  BucketList
//
//  Created by Gavin Woffinden on 7/1/21.
//

import UIKit

class BucketItemTableViewController: UITableViewController {
static let shared = BucketItemTableViewController()
    var refresh: UIRefreshControl = UIRefreshControl()
    var itemsArray: [String] = []
    
    
    @IBOutlet weak var progressButton: UIButton!
    @IBOutlet weak var itemTitleLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    @IBAction func progressButtonTapped(_ sender: Any) {
    }
    var itemsID: String? {
        didSet {
            loadData()
            print(itemsArray)
        }
    }
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refresh)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    @objc func loadData() {
    
        guard let id = itemsID else {return}
        BucketFirebaseFunctions.fetchBucketItems(itemsID: "NSHJF83N4GH5JKSJB8z") { result in
            let items = result["items"]
            self.itemsArray = items as! [String]
            self.updateViews()
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bucketItemCell", for: indexPath) as? BucketItemTableViewCell else {return UITableViewCell()}
        let item = itemsArray[indexPath.item]
        cell.item = item
      
        return cell
    }

  
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           
        }    
    }
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
