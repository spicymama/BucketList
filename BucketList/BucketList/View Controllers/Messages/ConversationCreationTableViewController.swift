//
//  ConversationCreationTableViewController.swift
//  BucketList
//
//  Created by Justin Webster on 6/23/21.
//

import UIKit

class ConversationCreationTableViewController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet weak var user1TextField: UITextField!
    @IBOutlet weak var user2TextField: UITextField!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Properties
    var friends: [User]?
    
    //MARK: - Actions
    @IBAction func createConversationButtonTapped(_ sender: Any) {
        guard let user1 = user1TextField.text, !user1.isEmpty,
              let user2 = user2TextField.text, !user2.isEmpty else {return}
        
//        ConversationController.shared.createAndSaveConversation(userIDs: [user1, user2])
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Functions
    
    func fetchFriends() {
        
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
  

}//End of Class
