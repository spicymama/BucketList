//
//  AddBlockReportViewController.swift
//  BucketList
//
//  Created by Ethan Andersen on 6/30/21.
//

/*
import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuth

class AddBlockReportViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     //MARK: - Landing Pad
        var profileUser: User?
    }

    
    // MARK: - Actions
    @IBAction func addFriendBtn(_ sender: Any) {
        FriendsListModelController.sharedInstance.checkForBlockedUser()
        FriendsListModelController.sharedInstance.addFriend()
        
    }
    
    @IBAction func messageBtn(_ sender: Any) {
        FriendsListModelController.sharedInstance.checkForBlockedUser()
        
        
    }
    
    @IBAction func blockBtn(_ sender: Any) {
        FriendsListModelController.sharedInstance.blockUser(profileUID: "")
    }
    
    @IBAction func reportBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "What would you like to report?", message:  "Please give a brief description of the issue", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "What seems to be the problem?"
            
        }
        let doneAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let reportText = alertController.textFields?.first?.text, !reportText.isEmpty else { return }
            self.saveReportToDB(reportText: reportText, profileUID: "")
                  }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func saveReportToDB(reportText: String, profileUID: String) {
        let newReportRef = Firestore.firestore().collection("reports").document()
        newReportRef.setData([
            "reportText": reportText,
            "profileUID": profileUID,
            "lastupdated": FieldValue.serverTimestamp()
        ])
    }
    
    @IBAction func signOutBtn(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let 🛑 as NSError {
            print("Error signing out: %@", 🛑)
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authenticate", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    } // End of Sign out button
    
} // End of Class
*/
