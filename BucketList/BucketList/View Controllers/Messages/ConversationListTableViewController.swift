//
//  ConversationListTableViewController.swift
//  BucketList
//
//  Created by Justin Webster on 6/22/21.
//

import UIKit

class ConversationListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //JCW - fix user data source
        FirebaseFunctions.fetchCurrentUserData { user in
            ConversationController.shared.currentUser = user
            self.fetchConversations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseFunctions.fetchCurrentUserData { user in
            ConversationController.shared.currentUser = user
            self.fetchConversations()
        }    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationController.shared.conversations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath)

        let conversation = ConversationController.shared.conversations[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = conversation.conversationID
//        cell.conversation = conversation
        return cell
    }
 
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
   
    func updateViews() {
                
    }
    
    func fetchConversations () {
//        let user = UserController.shared.currentUser
        guard let user = ConversationController.shared.currentUser else {return}
        ConversationController.shared.fetchConversationsFor(user) { result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case false:
                print("Error in \(#function)")
            }
        }
    }
//    func fetchUsersForConversation(_ conversation: Conversation) {
//        ConversationController.shared.fetchUsers(conversationID: conversation.conversationID) { result in
//            switch result {
//            case true:
//                self.updateViews()
//            case false:
//                print("Error in \(#function)")
//            }
//        }
//    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toMessagesVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ConversationMessagesViewController else {return}
            let conversation = ConversationController.shared.conversations[indexPath.row]
            destinationVC.conversation = conversation
        }
    }
}//End of Class
