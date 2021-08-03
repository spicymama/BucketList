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
        let conversationCount = ConversationController.shared.conversations.count

        return conversationCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as? ConversationTableViewCell else {return UITableViewCell()}

        let conversation = ConversationController.shared.conversations[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
//        cell.textLabel?.text = conversation.conversationID
        cell.conversation = conversation
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
                    if ConversationController.shared.conversations.count == 0 {
                        self.youHaveNoConversations()
                    }
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


    
    func youHaveNoConversations() {
        // Display statement that the user has no friends/Conversations
        let alert = UIAlertController(title: "Looks like you don't have any conversations!", message: "Lets find some friends to talk to!", preferredStyle: .alert)
        
        let cancelBtn = UIAlertAction(title: "Close", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelBtn)
        
        let startConversationBtn = UIAlertAction(title: "Start some Conversations!", style: .default) { _ in
            let storyboard: UIStoryboard = UIStoryboard(name: "justin", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "conversationCreationVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(startConversationBtn)
        
        present(alert, animated: true, completion: nil)
    } // End of You have no conversations
    
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
